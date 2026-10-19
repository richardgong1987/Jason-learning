#!/usr/bin/env python3
"""Run picnic scenarios in temporary copies with JASON_CLASSPATH and optional JAVA_HOME."""
import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'lessons/32-school-picnic'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--seconds', type=float, default=6)
    args = parser.parse_args()
    if args.seconds < 4:
        parser.error('--seconds must be at least 4 (protocol waits are 3 seconds)')
    cp = os.environ.get('JASON_CLASSPATH')
    if not cp:
        parser.error('Set JASON_CLASSPATH to the Jason interpreter and dependencies')
    cp = os.pathsep.join(str(Path(p).absolute()) for p in cp.split(os.pathsep) if p)
    java = (str(Path(os.environ['JAVA_HOME']) / 'bin' / ('java.exe' if os.name == 'nt' else 'java'))
            if os.environ.get('JAVA_HOME') else shutil.which('java') or 'java')
    scenarios = [
        ('rainy-default', {}, ['VALIDATED v=2 food=20 seats=20 games=indoor',
                              'CONFLICT insufficient transport seats',
                              'CONFLICT outdoor games in rain'], True),
        ('sunny', {'teacher.asl': [('forecast(rain)', 'forecast(sunny)')]},
         ['VALIDATED v=2 food=20 seats=20 games=outdoor'], True),
        ('smaller-group', {'teacher.asl': [('participants(20)', 'participants(12)')]},
         ['VALIDATED v=2 food=12 seats=12 games=indoor'], True),
        ('insufficient-seats', {'chloe.asl': [('max_seats(30)', 'max_seats(10)')]},
         ['REVISION REFUSED v=2 by=chloe reason=insufficient_transport_capacity',
          'PICNIC BLOCKED'], False),
        ('missing-readiness', {'participant.asl': [
            ('.send(teacher,tell,ready(V,P));',
             'if (not initial_plan(transport(_))) { .send(teacher,tell,ready(V,P)); };')]},
         ['PICNIC BLOCKED'], False),
    ]
    failures = 0
    with tempfile.TemporaryDirectory(prefix='jason-picnic-') as tmp:
        for name, edits, expected, success in scenarios:
            project = Path(tmp) / name
            shutil.copytree(SOURCE, project)
            for filename, replacements in edits.items():
                path = project / filename
                content = path.read_text()
                for old, new in replacements:
                    assert old in content, (filename, old)
                    content = content.replace(old, new)
                path.write_text(content)
            command = [java, '-Djava.awt.headless=true', '-cp', cp,
                       'jason.infra.local.RunLocalMAS', 'main.mas2j', '--no-net',
                       '--log-conf', str(ROOT / 'scripts/console.properties')]
            code = None
            try:
                result = subprocess.run(command, cwd=project, stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT, text=True, timeout=args.seconds)
                output, code = result.stdout, result.returncode
            except subprocess.TimeoutExpired as exc:
                output = (exc.stdout or b'').decode('utf-8', errors='replace')
            output = re.sub(r'(?<=\d)\.0(?=[, )\]\n]|$)', '', output)
            errors = [f'missing {s}' for s in expected if s not in output]
            if code not in (None, 0):
                errors.append(f'exit status {code}')
            if re.search(r'SEVERE|Exception|Error|No applicable plan|Could not find', output):
                errors.append('runtime diagnostic')
            if success:
                if 'PICNIC READY' not in output or 'PICNIC BLOCKED' in output:
                    errors.append('team success required')
                if output.count('EXECUTED v=2') != 3 or 'EXECUTED v=1' in output:
                    errors.append('each participant must execute version 2 once')
                for worker in ('alice', 'ben', 'chloe'):
                    if output.count('[' + worker + '] EXECUTED v=2') != 1:
                        errors.append('incorrect execution count for ' + worker)
                barrier = output.find('ALL READY v=2')
                if barrier < 0 or barrier > output.find('EXECUTED v=2'):
                    errors.append('execution preceded readiness barrier')
                if output.rfind('EXECUTED v=2') > output.find('PICNIC READY'):
                    errors.append('team success preceded execution')
            elif 'PICNIC READY' in output or 'EXECUTED v=' in output:
                errors.append('blocked plan must never execute or claim success')
            if errors:
                failures += 1
                print(f'FAIL {name}: {errors}\n{output}')
            else:
                print(f'PASS {name}')
    print(f'{len(scenarios) - failures}/{len(scenarios)} picnic scenarios passed')
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
