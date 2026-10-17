# Lesson 27: Sharing source files and separating namespaces

## The situation

Two modules use the same predicate name without sharing the same state. An include directive loads reusable source definitions.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/27-include-and-namespaces
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
{ include("shared.asl") }
stock::available(book).
shipping::available(van).
!start.
+!start <- !greet;
           ?stock::available(Item);
           ?shipping::available(Vehicle);
           .print("Stock item: ",Item);
           .print("Shipping vehicle: ",Vehicle).
```

## How it works

- `{ include("shared.asl") }` loads the shared greeting plan when the source is parsed. Run from this lesson directory so the relative include resolves.
- `stock::available` and `shipping::available` are predicates in different namespaces. Neither is the default-namespace predicate `available`.
- A namespace organizes the belief/plan vocabulary within an agent. It does not create a new agent, thread, or private security boundary.
- **B:** namespaced availability facts. **D:** start and greet. **I:** start with the included greeting subplan.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Hello from the included plan
Stock item: book
Shipping vehicle: van
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Add `shipping::available(truck).` and collect all vehicles.
2. Query plain `available(book)` and predict the result.

<details>
<summary>Hints and answers — predict first</summary>

Use `.findall(V,shipping::available(V),Vehicles)` for all vehicles. The default-namespace query does not find the stock fact.

</details>

## Explain it aloud

Two modules use the same predicate name without sharing the same state. An include directive loads reusable source definitions. - `{ include("shared.asl") }` loads the shared greeting plan when the source is parsed. Run from this lesson directory so the relative include resolves.
- `stock::available` and `shipping::available` are predicates in different namespaces. Neither is the default-namespace predicate `available`.
- A namespace organizes the belief/plan vocabulary within an agent. It does not create a new agent, thread, or private security boundary.
- **B:** namespaced availability facts. **D:** start and greet. **I:** start with the included greeting subplan.

## Included file

`shared.asl` contains the greeting plan. Changing it changes the next fresh run of any source that includes it.

