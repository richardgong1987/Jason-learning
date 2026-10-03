# Lesson 2: Choose a Delivery Plan Using Beliefs

**Goal:** run the delivery example and see how the same goal can select different plans depending on the elevator's state.

## Run

From the repository root:

```bash
cd lessons/02-delivery
jason delivery.mas2j
```

Expected key output:

```text
[robot] Taking the stairs.
[robot] Delivering food to alice
```

## Read the Code

Open `robot.asl`:

- `elevator(broken).` is an initial belief.
- `!deliver(alice).` is an initial achievement goal.
- Both plans match `+!deliver(Customer)`, but their context conditions differ.
- The condition after `:` is evaluated against the agent's beliefs.
- `Customer` is a variable because its name starts with an uppercase letter. It is bound to `alice` when the plan matches this goal.
- `;` separates execution steps in the plan body.
- `+delivered(Customer)` adds a belief during execution.

Read this plan as a sentence:

```prolog
+!deliver(Customer) : elevator(broken)
    <- .print("Taking the stairs.");
       .print("Delivering food to ", Customer);
       +delivered(Customer).
```

“When a new delivery goal appears, if I believe the elevator is broken, take the stairs, print the delivery message, and record that the delivery is complete.”

The first plan requires `elevator(working)`. That belief is absent, so its condition does not hold. The second plan requires `elevator(broken)`, which is present, so the robot chooses the stairs.

A belief is information the agent holds, which can differ from reality. Printing a message and adding a belief only simulate delivery; they do not move a real robot or independently verify success.

## Where Is the Intention?

There is no field called `intention` in this source file. Jason selects and instantiates a plan, then adds it to an executing intention. A plan is an available method; an intention is a commitment to execute an instantiated plan.

## Exercises

1. Replace `elevator(broken).` with `elevator(working).`. Stop and rerun. Expect `Taking the elevator.` Keep exactly one elevator state.
2. Change the initial goal from `!deliver(alice).` to `!deliver(bob).`. Expect the recipient to change to bob without modifying either plan.
3. Predict what happens if you remove both elevator states. Neither context holds, so the goal fails because there is no applicable plan. A false context does not automatically make the goal wait until that context becomes true.

## Explain It Aloud

> The agent believes that the elevator is broken. It has a goal to deliver food to Alice. Jason selects the plan whose context is true. The agent takes the stairs and records the delivery as complete.
