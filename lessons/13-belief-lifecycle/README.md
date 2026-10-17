# Lesson 13: Belief addition, deletion, replacement, and events

## The situation

A robot changes its battery reading and removes an obsolete task. Belief changes can trigger other plans, but those reactions may interleave with the original intention.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/13-belief-lifecycle
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
battery(20).
task(old).
!start.
+!start <- +task(new);
           -task(old);
           -+battery(100);
           .abolish(task(_));
           ?battery(Level);
           .print("Final battery: ",Level).
+task(new) <- .print("Reactive: new task observed").
-task(old) <- .print("Reactive: old task removed").
```

## How it works

- `+p` in a body adds a belief; `-p` removes a matching belief; `-+p` performs replacement. In a plan trigger, `+p`/`-p` instead match events caused by changes.
- `-+battery(100)` removes existing `battery(...)` entries using generalized arguments and adds the new reading. Do not use `-+stock(book,N)` to update one product when other stock records must survive; explicitly remove `stock(book,Old)` and add `stock(book,New)`.
- `.abolish(task(_))` removes all matching task beliefs; use it when removing all matches is intended.
- The reaction plans respond to events even if the current belief base has changed again before their execution. An event reports a change, not a promise that the belief still holds now.
- **B:** battery/tasks. **D:** start. **I:** the updating plan and any selected reaction plans. **Reactive:** the `+task` and `-task` triggers.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Final battery: 100
Reactive: new task observed
Reactive: old task removed
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Query tasks after `.abolish` with `.findall`.
2. Add a context `: task(new)` to the addition reaction and predict why it can behave differently.

<details>
<summary>Hints and answers — predict first</summary>

The final task list is empty. A reaction context checks the current belief base when selected; a rapidly abolished fact might no longer be true by then. Event handling and current-state checks answer different questions.

</details>

## Explain it aloud

A robot changes its battery reading and removes an obsolete task. Belief changes can trigger other plans, but those reactions may interleave with the original intention. - `+p` in a body adds a belief; `-p` removes a matching belief; `-+p` performs replacement. In a plan trigger, `+p`/`-p` instead match events caused by changes.
- `-+battery(100)` removes existing `battery(...)` entries using generalized arguments and adds the new reading. Do not use `-+stock(book,N)` to update one product when other stock records must survive; explicitly remove `stock(book,Old)` and add `stock(book,New)`.
- `.abolish(task(_))` removes all matching task beliefs; use it when removing all matches is intended.
- The reaction plans respond to events even if the current belief base has changed again before their execution. An event reports a change, not a promise that the belief still holds now.
- **B:** battery/tasks. **D:** start. **I:** the updating plan and any selected reaction plans. **Reactive:** the `+task` and `-task` triggers.
