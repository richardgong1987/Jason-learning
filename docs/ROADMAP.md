# Roadmap: From Jason Basics to an Advanced Trading Demo

## Final Objective

Build an advanced demonstration in which Jason coordinates an existing Python trading project, an AI model, and cTrader. The demo should make the agents' decisions, goals, failures, and recovery visible. Its evaluation concerns correct collaboration and execution behaviour, not a claim of trading profitability.

The integrated capstone is the final destination. It is not implemented yet. Lesson 6 is the first local trading-coordination exercise.

## Stages and Completion Checks

| Stage | Deliverable | Complete when |
| --- | --- | --- |
| 1: Foundations | Lessons 1–5 | Each example runs and its beliefs, goals, plans, and messages can be explained |
| 2: Local trading coordination | Lesson 6 | The filled, rejected, and unknown scenarios are observed |
| 3: Changing commitments | A cancellation and suspend/resume lesson | A cancellation prevents a pending command; resuming rechecks current conditions |
| 4: Python bridge | Versioned message contracts and a local adapter | A Jason goal invokes Python work and a correlated reply updates the agent's beliefs |
| 5: Existing strategy | Adapter for the user's Python project | Real project calculations are returned for recorded market data without rewriting the strategy |
| 6: AI analysis | Provider-neutral interface, deterministic fixture, then selected model | Valid, invalid, timed-out, and late responses are handled distinctly |
| 7: Paper execution | An execution ledger and replay scenarios | Duplicate commands do not create duplicate paper orders; uncertainty is reconciled |
| 8: cTrader demo account | One selected broker-execution adapter | Account state, symbols, demo orders, and execution reports flow through the same interface |
| 9: Final demonstration | Integrated scenarios with visible BDI state and an event trace | Every acceptance scenario in the capstone has an observable result |

Only stages 1 and 2 have example source code in this update. Stage 2 still needs runtime verification in Jason. Stages 3–9 are planned work.

## Existing cTrader Code

Prefer integrating the existing C# cBot approach through a Python bridge, preserving its bar/tick handling and broker-specific execution logic. Strategy calculations and AI calls should be performed outside the fast tick loop. Exact responsibilities will be settled after reading the actual cBot and Python repositories.

cTrader Algo officially supports HTTP and WebSocket access. cTrader Open API also supports external applications and has an official Python SDK. Open API is an alternative execution path if that fits the existing code better; the demo will choose one owner of order submission, rather than activate two independent executors.

## Decisions Needed Before External Integration

- The existing Python project's repository and the entry points to reuse.
- The cBot repository and its existing position-management responsibilities.
- The AI provider/model, and whether it analyses text, market features, or both.
- The demo instrument and timeframe.
- The connection approach: existing cBot bridge or cTrader Open API.

These missing details do not block the Jason foundation lessons. They do block claiming that the actual existing projects are integrated.

## Official References

- [Jason overview and capabilities](https://jason-lang.github.io/)
- [Jason goal-failure semantics](https://jason-lang.github.io/jason/faq.html)
- [Jason BDI tutorial: concurrent intentions, cancellation, suspension and resumption](https://github.com/jason-lang/jason/blob/main/doc/tutorials/hello-bdi/readme.adoc)
- [cTrader Algo network access](https://help.ctrader.com/ctrader-algo/guides/network-access/)
- [cTrader Open API](https://help.ctrader.com/open-api/)
- [Official cTrader Python SDK](https://help.ctrader.com/open-api/python-SDK/python-sdk-index/)
