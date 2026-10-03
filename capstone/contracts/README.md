# Proposed Integration Contracts

**Status: a draft boundary for future adapters, not an implemented HTTP API or broker protocol.** These names and examples are internal demo conventions. They are not cTrader Open API message definitions.

## Common Envelope

| Field | Meaning |
| --- | --- |
| schema_version | Contract version, initially 1 |
| message_id | Unique identity of this individual message |
| correlation_id | Identity shared by messages belonging to one workflow |
| kind | Message type |
| created_at | UTC timestamp |
| expires_at | Deadline for actionable analysis or proposals; null for historical result events |
| payload | Type-specific content |

Keep a separate stable `client_order_id` for the logical order. A transport retry uses a new message ID but retains the logical order identity. The execution adapter keeps a durable ledger, queries broker state for uncertain outcomes, and maps broker identifiers to this identity. It cannot assume exactly-once submission solely because a client ID is present.

## Planned Messages

| kind | Direction | Main content |
| --- | --- | --- |
| market.snapshot | Python to Jason | Quote/bar time, symbol, bid/ask, and feature references |
| analysis.request | Jason to Python | Market snapshot identity and strategy/model options |
| analysis.result | Python to Jason | Proposal or hold result, AI assessment and provenance |
| risk.decision | Risk role to coordinator | Approved/rejected, reasons, proposal identity and expiry |
| execution.command | Jason through bridge to executor | Approved proposal identity and stable logical order identity |
| execution.report | Executor through bridge to Jason | accepted, filled, rejected, cancelled or unknown, plus broker identifiers |
| workflow.cancel | Jason to bridge | Cancel pending workflow; do not confuse this with cancelling an already filled position |
| reconciliation.result | Executor to Jason | Current broker state for an uncertain logical order |

## Execution Validation

An adapter must validate proposal expiry, cancellation state, current account state, symbol precision and volume conventions, protective order requirements, and duplicate identity. Revalidate at the execution boundary; a risk decision based on an older snapshot is not sufficient.

The external integration must authenticate participants. Jason's internal message-source annotations alone do not authenticate arbitrary network senders.

## AI Response

The proposed model-facing result includes `assessment` (support/oppose/uncertain), `rationale`, input snapshot identity, and model metadata. It must not be accepted as an execution command. If a model reports confidence, treat it as a model output rather than a calibrated probability of profit.

Start with fixture responses. Choose and implement a provider only after its API and the intended analysis task are specified.

## Example

See [analysis-result.example.json](analysis-result.example.json). All prices and values are fabricated replay data. The fixed timestamps make the example historical and intentionally unsuitable for submitting a current order. No broker volume is specified; it must be computed and validated by the actual strategy and execution adapters.
