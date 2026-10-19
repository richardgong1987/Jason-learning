# Picnic verification

## Runtime and commands

Executed with Jason interpreter **3.3.0**, GlassFish JSON dependencies, and **Temurin Java 25.0.2** on Linux. The course setup remains Java 21 / Jason 3.3.0; Java 21 and the graphical CLI launch were not separately tested during this update. Direct headless `RunLocalMAS` execution was used.

From the repository root, with `JASON_CLASSPATH` pointing to the interpreter and dependencies and optional `JAVA_HOME`:

```bash
python3 scripts/run_checks.py --lesson 32 --seconds 6
python3 scripts/check_picnic.py --seconds 6
```

The dedicated checker creates temporary scenario copies and leaves the original lesson unchanged. Jason processes normally stay alive, so the checker terminates each after a bounded observation window. A timeout is not itself evidence of success; outcome assertions must pass and runtime error diagnostics are rejected.

## Scenarios and assertions

| Scenario | Required result |
| --- | --- |
| Rain, 20 participants | Detect transport and weather conflicts; agree on 20 meals, 20 seats, indoor games |
| Sunshine | Agree on outdoor games with sufficient food and transport |
| 12 participants | Revise meals and seats to 12 |
| Chloe can provide only 10 seats | Explicit refusal; no participant executes; no team success |
| Chloe does not acknowledge readiness | Bounded wait ends in blocked coordination; no execution or team success |

All successful scenarios require exactly one version-2 execution per participant, no version-1 execution, readiness before execution, and team success only after execution. Every run includes deliberate stale and duplicate execution requests.

## Scope

These checks establish the supplied scenarios, not all interleavings or real-world booking correctness. The lesson is an in-memory simulation with trusted agents, a fixed snapshot, and one revision round. It has no crash recovery, distributed atomic transaction, automatic commitment rollback, or live weather integration. Earlier lessons were not rerun in this update.
