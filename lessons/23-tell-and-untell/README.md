# Lesson 23: Tell, untell, achieve, and sender-aware replies

## The situation

A manager informs a worker about a job, asks it to process that job, and withdraws the information after receiving a completion reply.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/23-tell-and-untell
jason main.mas2j
```

## Read the program

### `manager.asl`

```asl
!start.
+!start <- .send(worker,tell,job(j1,book)); .send(worker,achieve,process(j1)).
+done(Id)[source(worker)] <- .print("Manager received completion: ",Id); .send(worker,untell,job(Id,book)).
```

### `worker.asl`

```asl
+!process(Id)[source(Sender)] : job(Id,Item)[source(Sender)]
    <- .print("Worker processed: ",Id); .send(Sender,tell,done(Id)).
-job(Id,Item)[source(manager)] <- .print("Worker saw job information withdrawn: ",Id).
```

## How it works

- `tell` sends information. The receiver stores it with a sender `source(manager)` annotation. `achieve` posts a goal in the receiver; it does not by itself prove acceptance or completion.
- The worker checks its stored sender-specific job fact and replies to the `Sender` captured from the achievement goal's annotation.
- `untell` withdraws the sender's contribution to a belief. It does not delete every possible source's knowledge and does not cancel an achievement intention.
- **B:** job and completion facts held separately by each agent. **D:** the worker's process goal. **I:** manager start and worker processing plans. **Reactive:** `+done` and `-job` message-related belief events.
- Messages are asynchronous; the explicit done reply is the completion protocol. This example does not model delivery failure.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Worker processed: j1
Manager received completion: j1
Worker saw job information withdrawn: j1
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Remove the completion reply and observe what the manager can no longer conclude.
2. Add a worker-local copy of the job belief and inspect what remains after untell.

<details>
<summary>Hints and answers — predict first</summary>

Without a reply the manager has no evidence of completion. A self-sourced copy can remain after the manager withdraws its own source annotation.

</details>

## Explain it aloud

A manager informs a worker about a job, asks it to process that job, and withdraws the information after receiving a completion reply. - `tell` sends information. The receiver stores it with a sender `source(manager)` annotation. `achieve` posts a goal in the receiver; it does not by itself prove acceptance or completion.
- The worker checks its stored sender-specific job fact and replies to the `Sender` captured from the achievement goal's annotation.
- `untell` withdraws the sender's contribution to a belief. It does not delete every possible source's knowledge and does not cancel an achievement intention.
- **B:** job and completion facts held separately by each agent. **D:** the worker's process goal. **I:** manager start and worker processing plans. **Reactive:** `+done` and `-job` message-related belief events.
- Messages are asynchronous; the explicit done reply is the completion protocol. This example does not model delivery failure.
