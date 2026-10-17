#!/usr/bin/env python3
"""Run lessons 07–30 with a supplied Jason 3.3.0 runtime; no third-party Python packages.

JASON_CLASSPATH must contain interpreter and runtime dependencies. JAVA_HOME is
optional if java and javac are already in PATH. Processes intentionally remain
alive after their goals, so each gets a bounded observation window then is killed.
"""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--lesson', type=int, help='Only run one new lesson (07–30)')
    parser.add_argument('--seconds', type=float, default=4, help='Observation window per lesson')
    args = parser.parse_args()
    if args.seconds < 2:
        parser.error('--seconds must be at least 2')
    cp = os.environ.get('JASON_CLASSPATH')
    if not cp:
        parser.error('Set JASON_CLASSPATH to the Jason interpreter and dependencies first')
    # Resolve relative entries before changing each project working directory.
    cp = os.pathsep.join(str(Path(p).absolute()) for p in cp.split(os.pathsep) if p)
    java_home = os.environ.get('JAVA_HOME')
    def executable(name):
        if java_home:
            return str(Path(java_home) / 'bin' / (name + ('.exe' if os.name == 'nt' else '')))
        return shutil.which(name) or name
    lessons = json.loads((ROOT / 'lesson-manifest.json').read_text())
    if args.lesson is not None:
        lessons = [x for x in lessons if x['number'] == args.lesson]
        if not lessons:
            parser.error('This checker covers lessons 07–30')
    failures = 0
    with tempfile.TemporaryDirectory(prefix='jason-learning-') as tmp:
        for lesson in lessons:
            number = lesson['number']
            project = ROOT / 'lessons' / lesson['folder']
            classes = Path(tmp) / str(number)
            classes.mkdir()
            sources = list((project / 'src' / 'java').rglob('*.java'))
            if sources:
                result = subprocess.run([executable('javac'), '-cp', cp, '-d', str(classes),
                                         *map(str, sources)], capture_output=True, text=True)
                if result.returncode:
                    failures += 1
                    print(f'FAIL {number:02d}: Java compilation\n{result.stdout}{result.stderr}')
                    continue
            command = [executable('java'), '-Djava.awt.headless=true', '-cp',
                       str(classes) + os.pathsep + cp, 'jason.infra.local.RunLocalMAS',
                       'main.mas2j', '--no-net', '--log-conf', str(ROOT / 'scripts/console.properties')]
            timed_out = False
            try:
                result = subprocess.run(command, cwd=project, stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT, text=True, timeout=args.seconds)
                output = result.stdout
            except subprocess.TimeoutExpired as exc:
                timed_out = True
                output = (exc.stdout or b'').decode('utf-8', errors='replace')
            normalized = re.sub(r'(?<=\d)\.0(?=[, )\]\n]|$)', '', output)
            errors = [f'missing: {x}' for x in lesson['expected'] if x not in normalized]
            if re.search(r'SEVERE|Exception|Error|No applicable plan|Could not find', output):
                errors.append('runtime diagnostic found')
            if not timed_out and result.returncode:
                errors.append(f'process exited with status {result.returncode}')
            if number == 20 and 'UNEXPECTED:' in output:
                errors.append('cancelled work executed')
            if number == 25 and normalized.count('EXECUTED request: r1') != 1:
                errors.append('side effect must execute exactly once')
            if number == 21 and 'Command accepted' in output:
                errors.append('authorization recheck bypassed')
            if errors:
                failures += 1
                print(f'FAIL {number:02d}: {"; ".join(errors)}\n{output}')
            else:
                print(f'PASS {number:02d}: {lesson["title"]}')
    print(f'{len(lessons) - failures}/{len(lessons)} lessons passed')
    return bool(failures)


if __name__ == '__main__':
    sys.exit(main())
