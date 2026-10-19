# Capstone verification

## Runtime

Validated with the published Jason interpreter **3.3.0**, GlassFish JSON dependencies, and **Temurin Java 25.0.2** on Linux. The reference scenario also passed with the locally available Jason 3.2.0 interpreter. The course setup remains Java 21 / Jason 3.3.0; this capstone was not separately executed on Java 21 during this update.

Direct `RunLocalMAS` execution was used with `--no-net`, headless mode, and console logging. The CLI-generated Gradle build and graphical Mind Inspector were not exercised.

## Reproduce

From the repository root, set `JASON_CLASSPATH` to the interpreter and its dependencies, and optionally `JAVA_HOME`:

```bash
python3 scripts/run_checks.py --lesson 31 --seconds 6
python3 scripts/check_firefighters.py --seconds 6
```

Each process is observed for six seconds and then terminated because Jason normally keeps running after the demonstration. A process timeout alone is not a pass: the check requires the relevant outcome markers and rejects runtime errors.

## Assertions

- Default: Alpha wins the hospital and Bravo wins the warehouse.
- Reduced Alpha water: Bravo wins the hospital and Alpha wins the warehouse.
- Lower hospital priority: warehouse is allocated first to Alpha, then hospital to Bravo.
- Insufficient water for both workers: coordination stops with no deployment or false success.
- Missing Bravo bid: the bounded wait expires and coordination stops with no deployment.
- Successful scenarios: exactly two work starts, exactly one completion per fire, completion from the assigned worker, and no cancelled round-1 deployment.
- Cancellation acknowledgement precedes the round-2 award.

The default dispatcher itself injects a stale deployment and duplicate valid deployments; these are exercised by the success scenarios. The checker modifies only temporary copies for alternative scenarios.

## Limits

These tests check the supplied scenarios, not every possible message interleaving. There is no persistent state, crash recovery, lost-award retry, ongoing-work preemption, or external fire simulator. The pending-fire queue and independent incident arrivals are learner extensions, not implemented features. Other lessons were not rerun in this capstone update.
