# Lesson 21: Suspending, resuming, and rechecking beliefs

## The situation

A robot pauses its job, changes the permission policy, and resumes. Resuming a commitment does not guarantee that its old assumptions still hold.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/21-suspend-and-resume
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
authorized.
!start.
+!start <- !!work;
           .wait(50);
           .suspend(work);
           .print("Work suspended");
           -authorized;
           .resume(work);
           .print("Work resumed").
+!work <- .wait(300); !commit.
+!commit : authorized <- .print("Command accepted").
+!commit : not authorized <- .print("Command blocked after recheck").
```

## How it works

- `.suspend(work)` pauses matching intentions; `.resume(work)` makes them eligible to continue. The controller is a different intention, so it can issue the resume.
- Resumption continues the selected plan; it does not automatically reselect the entire original plan or revalidate its old context.
- `!commit` deliberately selects a fresh plan using the current authorization belief. It illustrates an explicit recheck before the simulated command.
- **B:** authorization, later removed. **D:** work and commit. **I:** foreground controller and paused/resumed work. This is a teaching schedule using delays, not a distributed cancellation guarantee.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Work suspended
Work resumed
Command blocked after recheck
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Keep the authorization belief and predict the final branch.
2. Try suspending the controller itself as a thought experiment: who will resume it?

<details>
<summary>Hints and answers — predict first</summary>

If authorization remains, the accepted branch runs. A self-suspended controller needs another intention or agent to resume it; otherwise it may never reach its own resume step.

</details>

## Explain it aloud

A robot pauses its job, changes the permission policy, and resumes. Resuming a commitment does not guarantee that its old assumptions still hold. - `.suspend(work)` pauses matching intentions; `.resume(work)` makes them eligible to continue. The controller is a different intention, so it can issue the resume.
- Resumption continues the selected plan; it does not automatically reselect the entire original plan or revalidate its old context.
- `!commit` deliberately selects a fresh plan using the current authorization belief. It illustrates an explicit recheck before the simulated command.
- **B:** authorization, later removed. **D:** work and commit. **I:** foreground controller and paused/resumed work. This is a teaching schedule using delays, not a distributed cancellation guarantee.
