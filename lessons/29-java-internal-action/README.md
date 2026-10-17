# Lesson 29: Writing a Java internal action

## The situation

A robot calls a small Java function to calculate a shipping fee. An internal action runs within the agent interpreter and returns a value by unification.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/29-java-internal-action
jason main.mas2j
```

This lesson includes Java source. Use the compilation instructions below before launching.

## Read the program

### `robot.asl`

```asl
!start.
+!start <- demo.shipping_fee(3,Fee); .print("Shipping fee: ",Fee).
```

## How it works

- `.print` is a standard internal action, while `demo.shipping_fee` is a user-defined internal action whose Java package/class determines the dotted name.
- The implementation extends `DefaultInternalAction`, declares two arguments, checks the input, and unifies the result with the second argument.
- Returning `false` fails the body; throwing an argument error gives diagnostic information. Neither a Java return nor a log message automatically inserts a belief.
- **B:** none. **D:** start. **I:** the plan calling Java. Keep internal actions short; a blocking network call can block interpreter progress. Use asynchronous integration for slow I/O.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Shipping fee: 8
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Change the weight to 5.
2. Pass -1 and inspect the argument failure.
3. Bind Fee to an incorrect number before the call.

<details>
<summary>Hints and answers — predict first</summary>

The formula is 2 + 2 * weight, so weight 5 costs 12. A negative weight is rejected. An incompatible bound output makes unification fail.

</details>

## Explain it aloud

A robot calls a small Java function to calculate a shipping fee. An internal action runs within the agent interpreter and returns a value by unification. - `.print` is a standard internal action, while `demo.shipping_fee` is a user-defined internal action whose Java package/class determines the dotted name.
- The implementation extends `DefaultInternalAction`, declares two arguments, checks the input, and unifies the result with the second argument.
- Returning `false` fails the body; throwing an argument error gives diagnostic information. Neither a Java return nor a log message automatically inserts a belief.
- **B:** none. **D:** start. **I:** the plan calling Java. Keep internal actions short; a blocking network call can block interpreter progress. Use asynchronous integration for slow I/O.

## Java source and compilation

Read [`src/java/demo/shipping_fee.java`](src/java/demo/shipping_fee.java) alongside the ASL call.

From the repository root, set `JASON_CLASSPATH` to the classpath containing the Jason 3.3.0 interpreter and its dependencies, then run:

```bash
# Linux/macOS classpath separator is : ; Windows Java uses ;
# Example only: adapt these paths to your extracted Jason distribution.
export JASON_CLASSPATH="/absolute/path/to/jason/lib/*"
python3 scripts/run_checks.py --lesson 29
```

The checker compiles Java to a temporary directory and launches the project with that directory on the classpath. For a manual run from this lesson directory:

```bash
mkdir -p classes
javac -cp "$JASON_CLASSPATH" -d classes src/java/demo/shipping_fee.java
java -cp "classes:$JASON_CLASSPATH" jason.infra.local.RunLocalMAS main.mas2j --no-net
```

The simple `jason main.mas2j` command works only if your CLI build includes `src/java` in its Java source set (as the generated Lesson 1 build does). Do not use direct CLI mode without adding the compiled classes to its classpath.

