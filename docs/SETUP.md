# Setup and Troubleshooting

## Install Once

The current official Jason CLI installation guide uses Java 21.

1. Install JDK 21. Check that `java -version` reports version 21.
2. Download `jason-bin-...zip` from the [official releases page](https://github.com/jason-lang/jason/releases) and extract it to a permanent location.
3. Add the extracted distribution's `bin` directory to your PATH. Reopen your terminal and run `jason --version`.
4. Open this repository in VS Code or another text editor.

### Windows

The official guide recommends Git Bash. After installing Java 21 and Jason, run these commands in Git Bash:

```bash
java -version
jason --version
```

Use Windows environment-variable settings to add Jason's `bin` directory to your user Path. Close and reopen Git Bash after changing Path.

### macOS and Linux

Add the extracted `bin` directory to your shell's PATH. For a temporary configuration:

```bash
export PATH="/your/path/to/jason/bin:$PATH"
jason --version
```

Replace the example path with the actual installation path. If the `jason` script is not executable, enter its `bin` directory and run `chmod +x jason`. For a permanent PATH configuration, add the appropriate line to the startup configuration of the shell you use.

## Run Lesson 1

From the repository root:

```bash
cd lessons/01-hello
jason hello.mas2j
```

Every lesson contains its own `.mas2j` configuration and `.asl` source files. Lessons 01–28 do not require you to write a Java environment. Lessons 29–30 include Java source and have additional compilation instructions in their READMEs. You do not need to run `jason app create` to study the ASL examples.

The ASL-only lessons use the standard Jason runtime. If the usual launch command encounters Gradle or download problems, the official CLI also provides a direct launch command:

```bash
jason mas start --mas2j=hello.mas2j
```

Run it from the first lesson's directory. For another lesson, use its configuration filename.

## Stop and Rerun

If a graphical console opens, use its stop or exit controls to end the system. For a foreground terminal process, use Ctrl+C. Stop the current system before rerunning edited code.

If a CLI-started system remains in the background, open another terminal and list running systems:

```bash
jason mas list
```

Then stop the system using its actual name:

```bash
jason mas stop <actual-system-name> --exit
```

Replace the placeholder, including the angle brackets, with the name from the list.

## Common Problems

| Symptom | What to check |
| --- | --- |
| `jason: command not found` | Is Jason's bin directory in PATH? Did you reopen the terminal? |
| Java version error | Does `java -version` report 21? Is PATH selecting an older JDK? |
| Configuration file not found | Are you in the correct lesson directory? |
| Agent source file not found | Is the `.asl` file beside the configuration, with the matching name? |
| Syntax error | Check `.`, `;`, `:`, and `<-` and the location of the reported error. |
| No applicable plan | Does the event match a plan, and is its context condition true? |
| An edit has no effect | Did you stop the old system and launch the correct lesson again? |
| Output finishes but the console stays open | The agent is waiting for new events; this is normal. |

Logs and console formatting can vary between Jason versions. Each lesson lists the key messages to look for; the complete log does not need to match word for word.


## Extended-course checks

The automated checker covers lessons 07–30. Install JDK 21 (including `javac`), Python 3, and the Jason 3.3.0 interpreter with its runtime dependencies. Set `JASON_CLASSPATH` to the extracted distribution's runtime JARs; the actual distribution layout may differ.

```bash
export JASON_CLASSPATH="/absolute/path/to/jason/lib/*"
python3 scripts/run_checks.py
python3 scripts/run_checks.py --lesson 16
```

The checker uses a temporary compilation directory for Java, console logging, an isolated process per lesson, and a bounded observation window. See [verification](VERIFICATION.md). When launching manually on Windows use `;` rather than `:` between Java classpath entries; the Python checker uses the platform-specific separator automatically.
