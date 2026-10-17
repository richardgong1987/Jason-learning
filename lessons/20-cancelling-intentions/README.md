# Lesson 20: Inspecting and cancelling a background goal

## The situation

A robot starts a long-running job and then cancels it before it reaches completion.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/20-cancelling-intentions
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
!start.
+!start <- !!work;
           .wait(50);
           if (.intend(work)) { .print("Work is intended"); };
           .drop_intention(work);
           .print("Work cancelled").
+!work <- .wait(1000); .print("UNEXPECTED: cancelled work completed").
```

## How it works

- `.intend(work)` inspects whether a matching goal is currently intended, including a suspended intention.
- `.drop_intention(work)` drops matching intentions. It does not undo effects already produced and is not a transactional rollback.
- Here the job waits long enough for the cancellation demonstration. In a real protocol, use an acknowledgement and recheck authorization at the point of action, rather than depending on a sleep duration.
- **B:** none. **D:** work requested. **I:** foreground plus the waiting work intention, which is removed. The work-completion message must not appear.
- `.drop_desire` is broader: it can also remove matching pending events. The distinction matters when a goal has not yet become an intention.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Work is intended
Work cancelled
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Remove `.drop_intention` and wait for the completion print.
2. Move a print before the work delay. Can cancellation undo it?

<details>
<summary>Hints and answers — predict first</summary>

Without cancellation the job finishes. Already executed effects remain, including prints or external commands. Cancellation controls future processing, not history.

</details>

## Explain it aloud

A robot starts a long-running job and then cancels it before it reaches completion. - `.intend(work)` inspects whether a matching goal is currently intended, including a suspended intention.
- `.drop_intention(work)` drops matching intentions. It does not undo effects already produced and is not a transactional rollback.
- Here the job waits long enough for the cancellation demonstration. In a real protocol, use an acknowledgement and recheck authorization at the point of action, rather than depending on a sleep duration.
- **B:** none. **D:** work requested. **I:** foreground plus the waiting work intention, which is removed. The work-completion message must not appear.
- `.drop_desire` is broader: it can also remove matching pending events. The distinction matters when a goal has not yet become an intention.
