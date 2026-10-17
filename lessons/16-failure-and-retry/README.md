# Lesson 16: Goal failure, bounded retry, and recovery

## The situation

The robot tries to open a door. Its first attempt fails, so a failure-handling plan changes the conditions and explicitly retries once.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/16-failure-and-retry
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
door(locked).
attempt(0).
!start.
+!start <- !open; .print("Parent continues after recovery").
+!open : door(locked) <- .print("Door locked: attempt fails"); .fail.
+!open : door(unlocked) <- .print("Door opened").
-!open : attempt(0)
    <- -+attempt(1); -+door(unlocked); !open.
-!open : attempt(1)
    <- .print("Retry exhausted"); .fail.
```

## How it works

- `-!open` handles failure of an achievement goal. It is not a request to delete a belief named open.
- `.fail` deliberately fails the current body. Jason does not automatically try every alternative recipe after a body fails; recovery must be designed.
- The recovery plan increments the attempt belief, changes the simulated door state, and posts a new `!open` subgoal. When recovery succeeds the suspended parent can continue.
- The second handler fails after the retry budget is exhausted; it does not report false success or create an infinite retry loop. This example simulates unlocking with beliefs; a real door needs an external action.
- **B:** door and attempt. **D:** open. **I:** parent, open attempt, and recovery stack. Recovery must consider side effects already performed before failure.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Door locked: attempt fails
Door opened
Parent continues after recovery
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Remove the unlock update and observe the bounded exhausted path.
2. Remove the final `.fail` from the exhausted handler and explain the false-success problem.

<details>
<summary>Hints and answers — predict first</summary>

Without unlocking, the second opening fails and the exhausted handler propagates failure. A handler ending with a successful print instead consumes the failure, allowing the parent to continue despite the door remaining locked.

</details>

## Explain it aloud

The robot tries to open a door. Its first attempt fails, so a failure-handling plan changes the conditions and explicitly retries once. - `-!open` handles failure of an achievement goal. It is not a request to delete a belief named open.
- `.fail` deliberately fails the current body. Jason does not automatically try every alternative recipe after a body fails; recovery must be designed.
- The recovery plan increments the attempt belief, changes the simulated door state, and posts a new `!open` subgoal. When recovery succeeds the suspended parent can continue.
- The second handler fails after the retry budget is exhausted; it does not report false success or create an infinite retry loop. This example simulates unlocking with beliefs; a real door needs an external action.
- **B:** door and attempt. **D:** open. **I:** parent, open attempt, and recovery stack. Recovery must consider side effects already performed before failure.
