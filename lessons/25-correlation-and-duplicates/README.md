# Lesson 25: Request IDs and duplicate-message handling

## The situation

A client repeats the same request. The worker records the request ID before replying so a duplicate does not repeat the simulated side effect.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/25-correlation-and-duplicates
jason main.mas2j
```

## Read the program

### `client.asl`

```asl
!start.
+!start <- .send(worker,achieve,request(r1,book)); .send(worker,achieve,request(r1,book)).
+done(Id)[source(worker)] <- .print("Client observed completion: ",Id).
```

### `worker.asl`

```asl
@execute[atomic]
+!request(Id,Item)[source(Sender)]
    <- if (not processed(Id)) {
           +processed(Id); .print("EXECUTED request: ",Id);
       } else { .print("DUPLICATE request: ",Id); };
       .send(Sender,tell,done(Id)).
```

## How it works

- `request(r1,book)` carries a correlation ID. The reply includes the same ID, allowing a caller to associate responses with requests.
- The worker's `@execute[atomic]` plan makes its short local check/update sequence run without other intentions of that agent interleaving. It contains no wait or external operation.
- `processed(Id)` is an in-memory deduplication ledger. A replay takes the second branch and returns the same completion fact.
- Repeated identical tell replies can merge into one stored belief and need not produce two addition events. Count actual execution at the worker, rather than counting client belief events.
- **B:** processed IDs. **D:** handling requests. **I:** worker handlers and client start. **Reactive:** client done event. This is not durable exactly-once execution; a restart loses the ledger, and real external side effects require reconciliation.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
EXECUTED request: r1
DUPLICATE request: r1
Client observed completion: r1
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Send another request with ID r2.
2. Use the same ID for a different item and identify the missing validation rule.

<details>
<summary>Hints and answers — predict first</summary>

A fresh ID executes once. A production ledger must remember the payload/result and reject an ID reused with different content, rather than silently treating it as the original request.

</details>

## Explain it aloud

A client repeats the same request. The worker records the request ID before replying so a duplicate does not repeat the simulated side effect. - `request(r1,book)` carries a correlation ID. The reply includes the same ID, allowing a caller to associate responses with requests.
- The worker's `@execute[atomic]` plan makes its short local check/update sequence run without other intentions of that agent interleaving. It contains no wait or external operation.
- `processed(Id)` is an in-memory deduplication ledger. A replay takes the second branch and returns the same completion fact.
- Repeated identical tell replies can merge into one stored belief and need not produce two addition events. Count actual execution at the worker, rather than counting client belief events.
- **B:** processed IDs. **D:** handling requests. **I:** worker handlers and client start. **Reactive:** client done event. This is not durable exactly-once execution; a restart loses the ledger, and real external side effects require reconciliation.
