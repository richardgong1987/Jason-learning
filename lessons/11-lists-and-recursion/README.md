# Lesson 11: Lists, head/tail patterns, and recursion

## The situation

The robot processes a shopping list one item at a time. The empty list is the stopping condition.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/11-lists-and-recursion
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
!start.
+!start <- Items = [book,pen,bag];
           .length(Items,N);
           .print("Items: ",N);
           !pack(Items).
+!pack([]) <- .print("Packing complete").
+!pack([Head|Tail]) <- .print("Pack: ",Head); !pack(Tail).
```

## How it works

- `[book,pen,bag]` is a list. `[Head|Tail]` matches its first element and remaining list.
- `.length` is a standard internal action; its second argument receives the length through unification.
- `!pack(Tail)` makes a recursive subgoal in the current intention. The empty-list plan is the base case; omitting it causes failure at the end.
- **B:** none initially. **D:** packing each remaining list. **I:** one intention with nested pack plans. Recursion does not itself create parallel intentions.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Items: 3
Pack: book
Pack: pen
Pack: bag
Packing complete
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Run with `[]`.
2. Add another element.
3. Print a message after the recursive subgoal and predict its reverse order during unwinding.

<details>
<summary>Hints and answers — predict first</summary>

The empty input immediately prints completion. Each nonempty call removes one item. Code after the recursive call executes as the stack unwinds, from the last item back to the first.

</details>

## Explain it aloud

The robot processes a shopping list one item at a time. The empty list is the stopping condition. - `[book,pen,bag]` is a list. `[Head|Tail]` matches its first element and remaining list.
- `.length` is a standard internal action; its second argument receives the length through unification.
- `!pack(Tail)` makes a recursive subgoal in the current intention. The empty-list plan is the base case; omitting it causes failure at the end.
- **B:** none initially. **D:** packing each remaining list. **I:** one intention with nested pack plans. Recursion does not itself create parallel intentions.
