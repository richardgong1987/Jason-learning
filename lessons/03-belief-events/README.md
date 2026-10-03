# Lesson 3: React to a New Belief

**Goal:** distinguish a new-goal event from a belief-addition event.

## Run

From the repository root:

```bash
cd lessons/03-belief-events
jason belief_events.mas2j
```

Expected key output:

```text
[robot] Taking the stairs.
[robot] Delivering food to alice
[robot] Delivery completed for alice
```

## What Changed?

Compared with Lesson 2, the agent has one additional plan:

```prolog
+delivered(Customer)
    <- .print("Delivery completed for ", Customer).
```

When the delivery plan executes `+delivered(alice)`, the belief base changes. This produces a belief-addition event. The new plan matches that event and prints the confirmation.

Compare the expressions:

| Expression and location | Meaning |
| --- | --- |
| `+!deliver(Customer)` in a plan head | Match a new achievement-goal event |
| `+delivered(Customer)` in a plan head | Match a belief-addition event |
| `+delivered(Customer)` in a plan body | Execute a belief addition |

The same expression has different roles in a plan head and a plan body: one matches an event; the other performs an operation.

## Exercise

Change the confirmation message to `Customer notified: `, leaving the triggering event unchanged. Stop and rerun, then check the final message.

Adding exactly the same belief again from the same source normally does not change the belief base or produce another belief-addition event. Repeated belief additions should not be treated as a message queue.

## Explain It Aloud

> Adding a new belief can trigger another plan. The delivery plan records that the food has arrived. This belief change creates an event, and the agent reacts by printing a confirmation.
