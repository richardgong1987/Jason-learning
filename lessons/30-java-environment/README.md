# Lesson 30: External actions and environment percepts

## The situation

A robot sees a closed door through a Java environment, performs an external action, and observes the environment publish the opened-door percept.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/30-java-environment
jason main.mas2j
```

This lesson includes Java source. Use the compilation instructions below before launching.

## Read the program

### `robot.asl`

```asl
!start.
+!start : door(closed)
    <- open(door);
       .wait(door(open),1000);
       .print("Environment confirmed open door").
+door(open)[source(percept)] <- .print("Reactive percept: door is open").
```

## How it works

- `open(door)` is an external action: it has no leading dot and is delegated to the configured Java environment. It is not a belief update or a subgoal.
- The environment maintains its own state, removes the old percept, and publishes `door(open)`. Jason imports it as a `source(percept)` belief.
- The initial `door(closed)` context is satisfied by perception. The condition wait after the action is robust even if the open percept arrived before the wait registered.
- **B:** perceived door state. **D:** start. **I:** the selected action plan and the percept-reaction plan. **Reactive:** `+door(open)[source(percept)]`.
- This Java environment is still a simulation. It illustrates how to connect external state without pretending that `+door(open)` alone proves a physical action happened.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Environment confirmed open door
Reactive percept: door is open
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Return false from executeAction and inspect goal failure.
2. Stop publishing the open percept but return true: what does the bounded wait reveal?

<details>
<summary>Hints and answers — predict first</summary>

A false action result fails the intention. A true return without the confirming percept causes the wait to time out; action acceptance and observed state are separate checks.

</details>

## Explain it aloud

A robot sees a closed door through a Java environment, performs an external action, and observes the environment publish the opened-door percept. - `open(door)` is an external action: it has no leading dot and is delegated to the configured Java environment. It is not a belief update or a subgoal.
- The environment maintains its own state, removes the old percept, and publishes `door(open)`. Jason imports it as a `source(percept)` belief.
- The initial `door(closed)` context is satisfied by perception. The condition wait after the action is robust even if the open percept arrived before the wait registered.
- **B:** perceived door state. **D:** start. **I:** the selected action plan and the percept-reaction plan. **Reactive:** `+door(open)[source(percept)]`.
- This Java environment is still a simulation. It illustrates how to connect external state without pretending that `+door(open)` alone proves a physical action happened.

## Java environment

See [`src/java/demo/DoorEnvironment.java`](src/java/demo/DoorEnvironment.java). `main.mas2j` declares `environment: demo.DoorEnvironment`.

Compile and run with the same `JASON_CLASSPATH` setup as [Lesson 29](../29-java-internal-action/README.md):

```bash
# From the repository root:
python3 scripts/run_checks.py --lesson 30
```

For a manual run, enter this lesson directory, compile `src/java/demo/DoorEnvironment.java` into `classes`, and launch `RunLocalMAS` with `classes` plus the Jason dependencies on the classpath, as in Lesson 29. A CLI-generated build must include `src/java`.

