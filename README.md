# Jason Learning — From BDI Basics to an Advanced Trading Demo

A step-by-step introduction to Jason and AgentSpeak, leading to an advanced demo that combines Jason, an existing Python trading project, an AI model, and cTrader. Begin with one agent's goal and plan, then learn how two agents communicate. Every lesson is a separate project with explanations, commands, expected output, exercises, and a short passage for spoken English practice.

## Start with Lesson 1

1. Install Java 21 and Jason CLI: [setup instructions](docs/SETUP.md).
2. Clone this repository:

```bash
git clone https://github.com/richardgong1987/Jason-learning.git
cd Jason-learning
```

3. Run the first lesson:

```bash
cd lessons/01-hello
jason hello.mas2j
```

Look for `Hello! I am a Jason agent.` Change the greeting and run it again before moving to Lesson 2.

After completing a goal, Jason usually keeps running and waits for new events. An open console does not mean the program is stuck. Stop the current system before switching lessons or rerunning edited code.

## Learning Path

| Lesson | What you learn | Instructions |
| --- | --- | --- |
| 01 | Initial goals and plans | [Hello agent](lessons/01-hello/README.md) |
| 02 | Choosing a delivery route using beliefs | [Delivery plans](lessons/02-delivery/README.md) |
| 03 | Reacting to a new belief | [Belief events](lessons/03-belief-events/README.md) |
| 04 | Subgoals and belief updates | [Preparation subgoal](lessons/04-subgoals/README.md) |
| 05 | Communication between manager and robot | [Two agents](lessons/05-two-agents/README.md) |
| 06 | Trading coordination, rejection and goal-failure handling | [Paper trading workflow](lessons/06-trading-coordination/README.md) |

For each lesson: predict the output, run the original example, change one thing, stop and rerun, then explain the result in your own words.

## Advanced Trading Destination

The final objective is an advanced collaborative trading demonstration: Jason coordinates goals and recovery, the existing Python project computes strategy features, an AI model supplies structured analysis, and cTrader executes approved demo-account commands.

- [Learning roadmap and integration milestones](docs/ROADMAP.md)
- [Capstone architecture and acceptance scenarios](capstone/README.md)
- [Proposed message contracts](capstone/contracts/README.md)

Lesson 6 provides a local four-agent paper workflow now. The real Python, AI, and cTrader adapters are later milestones and are not connected in this repository update.

## The Mental Model

Think of a delivery robot:

- **Beliefs:** information it currently holds, such as “the elevator is broken.” Beliefs can be mistaken.
- **Goals:** outcomes it wants to achieve, such as delivering food to Alice.
- **Plans:** available methods for achieving goals or responding to events.
- **Intentions:** instantiated plans the agent has committed to executing at runtime.

A plan is an available method; an intention represents the agent's current commitment. You do not need to declare an `intention` variable in these examples.

The examples simulate routes, charging, and deliveries with printed messages and internal belief updates. They do not connect to a physical robot or independently verify a real delivery.

## Syntax Reference

| Expression | Meaning |
| --- | --- |
| `elevator(broken).` | Initial belief |
| `!deliver(alice).` | Initial achievement goal |
| `+!deliver(X)` | Match a new achievement-goal event |
| `+delivered(X)` in a plan head | Match a belief-addition event |
| `+delivered(X)` in a plan body | Add a belief |
| `-battery(low)` in a plan body | Remove a belief |
| `:` | Introduce the plan's context condition |
| `<-` | Introduce the plan's execution steps |
| `;` | Separate steps in a plan body |
| `.` | End a declaration or a complete plan |
| `X` or `Customer` | A variable: its name starts with an uppercase letter |
| `alice` or `broken` | An atom: its name starts with a lowercase letter |
| `.send(robot, achieve, Goal)` | Ask another agent to achieve a goal |
| `.send(manager, tell, Fact)` | Tell another agent a piece of information |

## Troubleshooting

See [setup and troubleshooting](docs/SETUP.md). When reporting a problem, include the lesson number, operating system, output of `java -version` and `jason --version`, complete error message, and any changes to the `.asl` file.

## Official References

- [Jason documentation](https://jason-lang.github.io/jason/)
- [CLI installation and execution](https://jason-lang.github.io/jason/jason-cli/readme.html)
- [Official Getting Started tutorial](https://jason-lang.github.io/jason/tutorials/getting-started/readme.html)
- [Official BDI tutorial](https://github.com/jason-lang/jason/blob/main/doc/tutorials/hello-bdi/readme.adoc)

## Verification Status

Project structure, documentation links, agent source-file references, and configuration references have been checked. The preparation environment has Java 17 and no Jason installation, so the examples have not been executed in Jason here. Expected output follows the documented syntax and execution model. Start by verifying Lesson 1 on your computer. These examples were written for this project.
