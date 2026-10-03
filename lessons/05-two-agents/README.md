# Lesson 5: Make Two Agents Cooperate

**Goal:** let a manager request a delivery and let a robot complete the task and reply.

## Run

From the repository root:

```bash
cd lessons/05-two-agents
jason two_agents.mas2j
```

Expected key output:

```text
[manager] Requesting delivery to alice.
[robot] Taking the stairs.
[robot] Delivering food to alice
[manager] Robot confirmed delivery to alice
```

## Two Separate Agents

The `.mas2j` configuration declares two agents, whose programs are in `manager.asl` and `robot.asl`. Each agent has its own beliefs and goals. They do not automatically share a belief base.

The robot has no initial delivery goal. It waits for the manager's request.

## Request a Goal with achieve

The manager sends:

```prolog
.send(robot, achieve, deliver(alice))
```

Under Jason's default message handling, `achieve` requests that the recipient achieve this goal. The robot chooses its delivery plan using its own elevator belief.

## Report Information with tell

The robot replies:

```prolog
.send(manager, tell, delivered(Customer))
```

Under default handling, `tell` adds the information to the recipient's belief base. The manager receives a belief with a source annotation, such as:

```prolog
delivered(alice)[source(robot)]
```

The manager reacts with this plan:

```prolog
+delivered(Customer)[source(robot)]
    <- .print("Robot confirmed delivery to ", Customer).
```

The annotation identifies which agent supplied the information. It does not independently prove that a delivery happened in the real world.

## Exercises

1. Change the manager's requested goal to `deliver(bob)`. Expect the delivery and confirmation messages to refer to bob.
2. Replace the robot's elevator belief with `elevator(working).`. The manager needs no changes: the robot chooses the elevator route itself.

If no confirmation arrives, the robot's goal may have failed. This introductory example does not implement timeouts, retries, or failure replies.

## Explain It Aloud

> The manager sends an achievement request to the robot. The robot chooses a delivery plan using its own beliefs. After the plan finishes, it tells the manager that the delivery is complete. The manager reacts to that new belief.
