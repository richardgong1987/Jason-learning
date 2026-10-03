# Lesson 4: Complete a Subgoal Before Continuing

**Goal:** break a delivery task into a preparation subgoal, update beliefs, and resume the parent plan.

## Run

From the repository root:

```bash
cd lessons/04-subgoals
jason subgoals.mas2j
```

Expected key output:

```text
[robot] Preparing the delivery.
[robot] Battery is low. Charging first.
[robot] Battery is full.
[robot] Delivering food to alice
[robot] Delivery completed for alice
```

## Read the Code

The delivery plan contains a subgoal:

```prolog
+!deliver(Customer)
    <- .print("Preparing the delivery.");
       !prepare;
       .print("Delivering food to ", Customer);
       +delivered(Customer).
```

The current delivery intention must complete `!prepare` before continuing with the remaining delivery steps. This does not independently start a Java thread.

The preparation plan with context `battery(low)` applies when the agent believes the battery is low:

```prolog
+!prepare : battery(low)
    <- .print("Battery is low. Charging first.");
       -battery(low);
       +battery(full);
       .print("Battery is full.").
```

- `-battery(low)` removes the low-battery belief.
- `+battery(full)` adds the full-battery belief.
- Once preparation succeeds, the parent delivery plan resumes.

Charging is simulated by updating internal beliefs. There is no physical charger or elapsed charging time.

## Exercises

1. Replace the initial belief `battery(low).` with `battery(full).`. Stop and rerun. Expect `Battery is already full.` followed by delivery.
2. Predict what happens if neither battery state is present. The preparation goal has no applicable plan and fails. This example has no failure-recovery plan, so the parent delivery goal cannot continue normally.

## Explain It Aloud

> The delivery goal contains a preparation subgoal. If the battery is low, the agent first runs a charging plan. When the subgoal succeeds, the delivery plan resumes.
