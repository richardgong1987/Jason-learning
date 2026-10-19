#!/usr/bin/env python3
"""Run capstone scenarios in temporary copies with JASON_CLASSPATH and optional JAVA_HOME."""
import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'lessons/31-firefighter-coordination'


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
        ('default', {}, ['FINAL hospital -> alpha', 'FINAL warehouse -> bravo'], True),
        ('low-water', {'alpha.asl': [('water(10)', 'water(3)')]},
         ['FINAL hospital -> bravo', 'FINAL warehouse -> alpha'], True),
        ('lower-priority', {'dispatcher.asl': [('fire(hospital,10,4)', 'fire(hospital,1,4)')]},
         ['FINAL warehouse -> alpha', 'FINAL hospital -> bravo'], True),
        ('no-capacity', {f: [('water(10)', 'water(2)')] for f in ['alpha.asl', 'bravo.asl']},
         ['NO ELIGIBLE FIREFIGHTER', 'COORDINATION STOPPED'], False),
        ('missing-bid', {'bravo.asl': [('{ include("firefighter.asl") }',
                                      '+!cfp(R,F,N)[source(dispatcher)] <- .print("SIMULATED SILENT BIDDER").')]},
         ['SIMULATED SILENT BIDDER', 'COORDINATION STOPPED'], False),
    ]
    failures = 0
    with tempfile.TemporaryDirectory(prefix='jason-firefighters-') as tmp:
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
                if 'CAPSTONE COMPLETE' not in output or 'COORDINATION STOPPED' in output:
                    errors.append('successful completion required')
                if output.count('EXECUTING round=') != 2:
                    errors.append('must execute exactly two jobs')
                completions = re.findall(r'EXTINGUISHED round=(\d+) fire=(\w+)', output)
                if len(completions) != 2 or {f for _, f in completions} != {'warehouse', 'hospital'}:
                    errors.append('must complete each fire once')
                if 'EXECUTING round=1' in output:
                    errors.append('cancelled reservation executed')
                released = output.find('CANCELLATION CONFIRMED')
                if released < 0 or released > output.find('AWARD round=2'):
                    errors.append('new award preceded cancellation acknowledgement')
                for allocation in expected:
                    fire, worker = allocation.removeprefix('FINAL ').split(' -> ')
                    if not re.search(r'\[' + worker + r'\] EXTINGUISHED round=\d+ fire=' + fire, output):
                        errors.append('wrong worker completed ' + fire)
            elif 'CAPSTONE COMPLETE' in output or 'EXECUTING round=' in output:
                errors.append('failed allocation must not deploy or claim success')
            if errors:
                failures += 1
                print(f'FAIL {name}: {errors}\n{output}')
            else:
                print(f'PASS {name}')
    print(f'{len(scenarios) - failures}/{len(scenarios)} capstone scenarios passed')
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
