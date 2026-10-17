# Lesson 7: Terms, variables, and unification

## The situation

A delivery robot receives a structured parcel description. Think of unification as fitting matching puzzle pieces together, rather than assigning a new value to a Java variable.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/07-terms-and-unification
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
!start.
+!start <- !inspect(parcel(alice,book,2));
           Pair = pair(tokyo,osaka);
           Pair = pair(From,To);
           .print("Route: ",From," -> ",To).
+!inspect(parcel(Customer,Item,Count))
    <- .print("Parcel: ",Customer," / ",Item," / ",Count).
```

## How it works

- `parcel(alice,book,2)` is a structure with a functor and three arguments; `alice` and `book` are atoms, and `2` is a number. A quoted value such as `"Route: "` is a string.
- `Customer`, `Item`, and `Count` are variables. Matching the goal against the trigger binds them to the corresponding terms.
- `=` unifies terms. `Pair = pair(From,To)` decomposes a structure already bound to `Pair`.
- A bound variable cannot later become a different term in the same execution. Use a fresh variable or update a belief to model changing state. Variables in different plan instances have separate bindings.
- **B:** none initially. **D:** `!start` and the requested inspection. **I:** the selected start plan with its inspection subplan on the runtime stack. The source plan is a recipe, not an intention by itself.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Parcel: alice / book / 2
Route: tokyo -> osaka
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Pass `parcel(bob,pen,5)` instead.
2. After binding `Pair`, try `Pair = pair(kyoto,osaka)`. Predict the failure.
3. Add an ignored fourth argument using `_` in the trigger.

<details>
<summary>Hints and answers — predict first</summary>

1. The three output values change. 2. Unification fails and the remaining body does not execute; this is not reassignment. 3. Both the goal and trigger need arity four; every `_` is a fresh anonymous variable.

</details>

## Explain it aloud

A delivery robot receives a structured parcel description. Think of unification as fitting matching puzzle pieces together, rather than assigning a new value to a Java variable. - `parcel(alice,book,2)` is a structure with a functor and three arguments; `alice` and `book` are atoms, and `2` is a number. A quoted value such as `"Route: "` is a string.
- `Customer`, `Item`, and `Count` are variables. Matching the goal against the trigger binds them to the corresponding terms.
- `=` unifies terms. `Pair = pair(From,To)` decomposes a structure already bound to `Pair`.
- A bound variable cannot later become a different term in the same execution. Use a fresh variable or update a belief to model changing state. Variables in different plan instances have separate bindings.
- **B:** none initially. **D:** `!start` and the requested inspection. **I:** the selected start plan with its inspection subplan on the runtime stack. The source plan is a recipe, not an intention by itself.
