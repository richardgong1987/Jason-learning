# Lesson 12: Enumerating answers: for, findall, setof, count

## The situation

A warehouse holds several customer orders. One query finds one answer; collection actions gather all matching answers.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/12-enumeration-and-collections
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
order(alice,book).
order(alice,pen).
order(bob,bag).
!start.
+!start <- for (order(Customer,Item)) {
               .print("Order: ",Customer," / ",Item);
           };
           .findall(C,order(C,_),Customers);
           .setof(C,order(C,_),Unique);
           .count(order(_,_),N);
           .sort(Customers,Sorted);
           .print("All customers: ",Sorted);
           .print("Unique customers: ",Unique);
           .print("Order count: ",N).
```

## How it works

- `for (Query) { Body }` iterates over solutions; use it for work that should happen once per match.
- `.findall(Template,Query,List)` builds a list with one template instance per answer, preserving duplicates. `.setof` returns sorted unique results. `.count` counts answers.
- `_` ignores an argument. Every occurrence is independent; two `_` values do not require equality.
- Do not depend on a belief database's iteration order. Sort a collection when the order matters, and do not mutate the collection being queried during this introductory loop.
- **B:** order records. **D:** start. **I:** the enumeration plan, rather than a separate intention per loop iteration.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Order: alice / book
Order: alice / pen
Order: bob / bag
All customers: [alice,alice,bob]
Unique customers: [alice,bob]
Order count: 3
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Add `order(bob,pen).` and predict count versus unique customers.
2. Replace the query with `order(charlie,_)`.

<details>
<summary>Hints and answers — predict first</summary>

The count becomes four while unique customers stays [alice,bob]. An empty query produces empty findall/setof lists and a zero count.

</details>

## Explain it aloud

A warehouse holds several customer orders. One query finds one answer; collection actions gather all matching answers. - `for (Query) { Body }` iterates over solutions; use it for work that should happen once per match.
- `.findall(Template,Query,List)` builds a list with one template instance per answer, preserving duplicates. `.setof` returns sorted unique results. `.count` counts answers.
- `_` ignores an argument. Every occurrence is independent; two `_` values do not require equality.
- Do not depend on a belief database's iteration order. Sort a collection when the order matters, and do not mutate the collection being queried during this introductory loop.
- **B:** order records. **D:** start. **I:** the enumeration plan, rather than a separate intention per loop iteration.
