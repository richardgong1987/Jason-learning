# Lesson 24: Remote queries with askOne and askAll

## The situation

A client asks a catalogue agent for one price and then for all products. A bounded synchronous query suspends only the asking intention.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/24-ask-one-and-all
jason main.mas2j
```

## Read the program

### `client.asl`

```asl
!start.
+!start <- .send(catalogue,askOne,price(book,P),Answer,1000);
           .print("One answer: ",Answer);
           .send(catalogue,askAll,price(Item,Cost),Answers,1000);
           .sort(Answers,Sorted); .print("All answers: ",Sorted).
```

### `catalogue.asl`

```asl
price(book,12).
price(pen,3).
```

## How it works

- The four/five-argument `.send` form binds a reply to the answer argument instead of relying on an incoming belief event.
- `askOne` returns a matching literal with sender provenance, not just the variable inside the query. `askAll` returns a list of matching literals.
- A timeout is represented by the atom `timeout`. A negative query result is different from a transport timeout; always inspect the returned term before destructuring it in a real client.
- **B:** catalogue prices in the server. **D:** client start. **I:** the asking intention waits while other intentions can still run. The server can answer directly from its belief base, without a hand-written request plan.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
One answer: price(book,12)[source(catalogue)]
All answers: [price(book,12)[source(catalogue)],price(pen,3)[source(catalogue)]]
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Query a missing product and print the returned term.
2. Try the three-argument asynchronous askOne and handle its reply as a belief event.

<details>
<summary>Hints and answers — predict first</summary>

A missing-answer reply is not a timeout. The asynchronous form returns immediately and later adds returned information as a sender-annotated belief.

</details>

## Explain it aloud

A client asks a catalogue agent for one price and then for all products. A bounded synchronous query suspends only the asking intention. - The four/five-argument `.send` form binds a reply to the answer argument instead of relying on an incoming belief event.
- `askOne` returns a matching literal with sender provenance, not just the variable inside the query. `askAll` returns a list of matching literals.
- A timeout is represented by the atom `timeout`. A negative query result is different from a transport timeout; always inspect the returned term before destructuring it in a real client.
- **B:** catalogue prices in the server. **D:** client start. **I:** the asking intention waits while other intentions can still run. The server can answer directly from its belief base, without a hand-written request plan.
