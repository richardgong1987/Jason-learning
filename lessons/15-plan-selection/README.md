# Lesson 15: Relevant plans, applicable plans, and labels

## The situation

Two recipes can respond to the same delivery goal. A matching trigger makes a plan relevant; a true context makes it applicable.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/15-plan-selection
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
route(stairs).
!start.
+!start <- !deliver(alice); -+route(elevator); !deliver(bob).
@by_elevator +!deliver(C) : route(elevator) <- .print("Elevator delivery: ",C).
@by_stairs +!deliver(C) : route(stairs) <- .print("Stairs delivery: ",C).
```

## How it works

- Both delivery plans are relevant to `+!deliver(...)`. Only the route whose context is true is applicable in each supplied call.
- `@by_elevator` and `@by_stairs` are plan labels. A label names a plan for inspection/removal; it is not a priority declaration.
- If multiple plans are applicable, the standard default selection picks the first option in its order. Custom agent selection can change this; use disjoint contexts when the decision matters.
- Changing a route belief does not automatically replace a plan already selected for an intention. Recheck important conditions before acting.
- **B:** route. **D:** deliveries. **I:** the selected route plan for each call.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Stairs delivery: alice
Elevator delivery: bob
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Start with `route(elevator).` instead.
2. Keep both route facts and inspect which plan is selected.
3. Add a `not route(elevator)` guard to the stairs context.

<details>
<summary>Hints and answers — predict first</summary>

Both deliveries use the elevator after the first change. With both facts present both plans are applicable; the default selects its first option. A negative guard makes the policy explicit rather than depending on source order.

</details>

## Explain it aloud

Two recipes can respond to the same delivery goal. A matching trigger makes a plan relevant; a true context makes it applicable. - Both delivery plans are relevant to `+!deliver(...)`. Only the route whose context is true is applicable in each supplied call.
- `@by_elevator` and `@by_stairs` are plan labels. A label names a plan for inspection/removal; it is not a priority declaration.
- If multiple plans are applicable, the standard default selection picks the first option in its order. Custom agent selection can change this; use disjoint contexts when the decision matters.
- Changing a route belief does not automatically replace a plan already selected for an intention. Recheck important conditions before acting.
- **B:** route. **D:** deliveries. **I:** the selected route plan for each call.
