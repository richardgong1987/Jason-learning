# Verification Report

## Runtime used

The new lessons target **Jason interpreter 3.3.0** and **Java 21**. Runtime verification was performed on Linux using OpenJDK 21.0.8 (provided by jdk4py), the published Jason 3.3.0 interpreter JAR, and GlassFish javax.json 1.1.4. Java extension source was compiled for Java 21 with Eclipse ECJ 3.39.0 because this execution environment initially had only a Java 17 runtime and no JDK compiler.

The checked-in runner uses your normal `javac` from a JDK 21 installation. The validation environment supplied an ECJ-backed compiler command with the same classpath/output arguments; it did not test a separately installed Oracle/OpenJDK javac binary.

## Results

**24/24 new lessons passed** the full Jason 3.3.0 run, including compilation and execution of both Java extension examples.

## Checks

- Launch each of the 24 new MAS projects in its own process with console logging and no Jason network services.
- Check all expected message fragments in `lesson-manifest.json` rather than treating a successful JVM launch as a successful lesson.
- Check that cancelled work never prints its completion marker (20), removed authorization never permits the command (21), and a repeated request executes its simulated side effect exactly once (25).
- Compile both Java extension examples, then verify their runtime results (29–30).
- Check all local Markdown links, agent source references, fenced code blocks, and agreement between README ASL listings and actual agent sources.
- In temporary copies, remove the retry unlock, remove cancellation, and retain authorization: verify retry exhaustion without parent success, work completion without cancellation, and acceptance when permission remains.

## Reproduce the main checks

From the repository root, with JDK 21 and Python 3 available:

```bash
export JASON_CLASSPATH="/absolute/path/to/jason/lib/*"
python3 scripts/run_checks.py
python3 scripts/run_checks.py --lesson 25
```

Use the actual path to the JARs in your Jason distribution. `JASON_CLASSPATH` must contain the interpreter and its runtime dependencies; this runner does not download them. Set `JAVA_HOME` when the right JDK is not already in PATH. The Python runner handles the host's classpath separator; manually written Java commands on Windows require `;` between classpath entries.

Each MAS normally remains alive after finishing its demonstration. The checker observes it for four seconds by default and then kills that process. A timeout is acceptable only when all expected messages and behavioral checks have passed and no runtime error was reported. Increase the observation window with `--seconds 8` on slower machines.

## Limits

The checks validate the supplied deterministic scenarios. They do not prove every possible interleaving or every learner modification correct. Delay-based concurrency demonstrations are teaching examples; production coordination needs explicit handshakes and state checks.

The original six lessons' source programs were preserved and were not included in the full new-course regression run. This work does not claim real Python, AI, broker, or physical-device integration. The standard Jason CLI's generated Gradle build and graphical console were not exercised here; direct interpreter execution was used for repeatable checks.
