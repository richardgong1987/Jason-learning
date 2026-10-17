# Lesson 18: Subgoals versus new intentions: ! and !!

## The situation

A robot starts a slow background job while doing foreground work. You can guarantee dependencies inside one intention, but cannot assume a total order between intentions.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/18-concurrent-intentions
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
!start.
+!start <- !sequential;
           !!background;
           .print("Foreground continues").
+!sequential <- .print("Sequential subgoal completed").
+!background <- .wait(100); .print("Background completed").
```

## How it works

- `!sequential` runs as a subgoal of the current intention. The caller resumes after that subgoal succeeds.
- `!!background` posts an achievement goal as a new intention; it is not joined automatically. Foreground work can continue independently.
- `.wait(100)` suspends only the background intention for roughly 100 milliseconds, allowing the agent to schedule other work.
- Concurrency here is Jason's interleaving of intentions. It is not a guarantee of one operating-system thread per goal.
- **B:** none. **D:** sequential and background work. **I:** the original stack plus a separate background stack. The delay illustrates interleaving; do not use elapsed time as a production synchronization protocol.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Sequential subgoal completed
Foreground continues
Background completed
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Replace `!!background` with `!background`.
2. Remove the delay and explain which relative ordering remains guaranteed.

<details>
<summary>Hints and answers — predict first</summary>

A single-exclamation subgoal must finish before the foreground print. Without the delay, only completion of the sequential subgoal before the later operations is guaranteed by this program; do not depend on the foreground/background print order.

</details>

## Explain it aloud

A robot starts a slow background job while doing foreground work. You can guarantee dependencies inside one intention, but cannot assume a total order between intentions. - `!sequential` runs as a subgoal of the current intention. The caller resumes after that subgoal succeeds.
- `!!background` posts an achievement goal as a new intention; it is not joined automatically. Foreground work can continue independently.
- `.wait(100)` suspends only the background intention for roughly 100 milliseconds, allowing the agent to schedule other work.
- Concurrency here is Jason's interleaving of intentions. It is not a guarantee of one operating-system thread per goal.
- **B:** none. **D:** sequential and background work. **I:** the original stack plus a separate background stack. The delay illustrates interleaving; do not use elapsed time as a production synchronization protocol.
