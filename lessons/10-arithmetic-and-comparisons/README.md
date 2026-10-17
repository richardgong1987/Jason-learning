# Lesson 10: Arithmetic, comparisons, and changing numeric state

## The situation

A warehouse calculates an invoice and then increments a stored counter. Calculating a value and updating stored state are separate operations.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/10-arithmetic-and-comparisons
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
price(book,12).
count(0).
!start.
+!start <- ?price(book,Price);
           Total = Price * 3 + 2;
           .print("Invoice total: ",Total);
           if (Total >= 30) { .print("Large order"); }
           else { .print("Small order"); };
           ?count(Old);
           New = Old + 1;
           -+count(New);
           .print("Counter: ",New).
```

## How it works

- In arithmetic positions Jason evaluates expressions such as `Price * 3 + 2`; the result here is 38. This is different from Java's assignment statement even though the symbol is familiar.
- Comparisons include `<`, `<=`, `>`, `>=`, `==`, and `\==`. Use `=` for unification and `==` for equality testing.
- `Old` keeps its binding. `New` holds a newly calculated result. `-+count(New)` replaces beliefs matching the same literal shape with fresh arguments; use this with care for predicates containing multiple records (Lesson 13).
- **B:** price and counter. **D:** start. **I:** the start plan. The `if` is a branch within one plan, rather than a new achievement goal.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Invoice total: 38
Large order
Counter: 1
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Change quantity to 2 and predict both outputs.
2. Try `Old = Old + 1` and explain why a bound variable cannot act as a Java counter.

<details>
<summary>Hints and answers — predict first</summary>

The invoice becomes 26 and the small-order branch runs. Use a fresh variable when calculating the next value; store persistent changes in beliefs.

</details>

## Explain it aloud

A warehouse calculates an invoice and then increments a stored counter. Calculating a value and updating stored state are separate operations. - In arithmetic positions Jason evaluates expressions such as `Price * 3 + 2`; the result here is 38. This is different from Java's assignment statement even though the symbol is familiar.
- Comparisons include `<`, `<=`, `>`, `>=`, `==`, and `\==`. Use `=` for unification and `==` for equality testing.
- `Old` keeps its binding. `New` holds a newly calculated result. `-+count(New)` replaces beliefs matching the same literal shape with fresh arguments; use this with care for predicates containing multiple records (Lesson 13).
- **B:** price and counter. **D:** start. **I:** the start plan. The `if` is a branch within one plan, rather than a new achievement goal.
