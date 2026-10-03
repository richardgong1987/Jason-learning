# Lesson 6: Coordinate a Paper Trading Workflow

**Goal:** see a more meaningful Jason example: separate agents produce a signal, evaluate a condition, execute a paper action, and respond to a failure.

This is a local Jason exercise. Python, an AI provider, and cTrader are not connected yet. The analyst uses fixed input and the execution agent prints simulated results. No broker is contacted.

## Run

From the repository root:

```bash
cd lessons/06-trading-coordination
jason trading.mas2j
```

## Agent Responsibilities

| Agent | Responsibility |
| --- | --- |
| coordinator | Starts each scenario and advances after its terminal report |
| analyst | Returns deterministic fixture data, standing in for a future Python/AI adapter |
| risk | Evaluates the spread condition and requests execution only when it passes |
| execution | Simulates a fill or failure and reports its outcome |

Each agent has its own belief base. Messages carry the scenario identifier so reports are correlated with the right task. Source annotations restrict which sender's messages match these plans; they are not a replacement for authentication at an external service boundary.

## Three Scenarios

| Scenario | Fixture input | Expected result |
| --- | --- | --- |
| accepted_trade | Spread 2 ticks, normal execution | filled |
| rejected_trade | Spread 12 ticks | rejected |
| uncertain_trade | Spread 2 ticks, simulated timeout | unknown |

The limit of 5 ticks is an arbitrary teaching value. This exercise does not calculate trade size or provide a trading strategy.

Look for these key messages, among other output:

```text
RESULT accepted_trade filled
RESULT rejected_trade rejected
RESULT uncertain_trade unknown
All paper scenarios complete. No broker was contacted.
```

The agent prefix and failure log format depend on the Jason version. The third scenario intentionally executes `.fail`, so a failure message is expected before the recovery report.

## Why Jason Matters Here

The coordinator posts achievement requests. The risk agent chooses a plan by evaluating a context condition. The execution agent has a goal-failure plan, `-!place(...)`, which reports uncertainty after a simulated failure. A belief-addition event delivers each result to the coordinator.

The coordinator advances based on replies, rather than sleeping for a guessed duration. It records `terminal(Id)` to avoid processing another terminal report for the same scenario during this run. This is not durable order idempotency; a future execution adapter must implement that separately.

A timeout is not automatically a rejected order. In a real integration, an acknowledgement can be lost after the broker accepts an order. The capstone will query broker state before deciding whether retrying is appropriate. This lesson only reports `unknown`; it does not implement that query.

## Exercises

1. Change the rejected scenario's spread from 12 to 3. Stop and rerun. It should now report filled.
2. Change the uncertain scenario's mode from timeout to normal. It should report filled without entering recovery.
3. Open Jason's Mind Inspector or debug view. Inspect each agent's beliefs and active intentions during execution. Explain which agent knows each fact.
4. Explain why the analyst's signal is a proposal, while execution is requested only after risk evaluation.

## Explain It Aloud

> This demo separates analysis, risk evaluation, execution, and coordination into four agents. The agents communicate using explicit messages. The risk agent chooses a plan based on its current beliefs. When execution fails, a failure-handling plan reports an unknown outcome. The coordinator uses the reply to advance the workflow.

## Verification Status

Source references and documentation links have been checked. This lesson has not been run in Jason in the preparation environment. Verify the three reported outcomes before proceeding to external integrations.

Next: [advanced trading capstone](../../capstone/README.md).
