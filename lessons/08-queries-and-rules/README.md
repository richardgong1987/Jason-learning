# Lesson 8: Test goals and derived beliefs

## The situation

The robot knows which customer lives in each city. A rule derives who is local without storing a separate local fact.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/08-queries-and-rules
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
lives(alice,tokyo).
lives(bob,osaka).
local(C) :- lives(C,tokyo).
!start.
+!start <- ?local(Customer);
           .print("Local customer: ",Customer);
           ?lives(bob,City);
           .print("Bob lives in ",City).
```

## How it works

- Facts and `Head :- Body.` rules belong to the belief base. A rule is used when queried; it does not automatically insert its head as a new fact or trigger `+local(...)`.
- `?local(Customer)` is a test goal. It queries beliefs/rules and binds a solution. It does not run every possible answer; use `for` or `.findall` for that later.
- `!g` asks for an outcome through achievement plans; `?p` asks whether information can be established.
- **B:** `lives` facts and the `local` rule. **D:** start. **I:** the start plan while executing its queries. There is no belief-change reactive plan here.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Local customer: alice
Bob lives in osaka
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Change Bob to live in Tokyo too. Does one test goal print both people?
2. Query `?lives(charlie,City)` and observe the missing-answer failure.

<details>
<summary>Hints and answers — predict first</summary>

A test goal chooses a solution, rather than enumerating all solutions in the rest of the plan. A missing belief/rule answer fails unless a matching test-goal plan supplies it (Lesson 17).

</details>

## Explain it aloud

The robot knows which customer lives in each city. A rule derives who is local without storing a separate local fact. - Facts and `Head :- Body.` rules belong to the belief base. A rule is used when queried; it does not automatically insert its head as a new fact or trigger `+local(...)`.
- `?local(Customer)` is a test goal. It queries beliefs/rules and binds a solution. It does not run every possible answer; use `for` or `.findall` for that later.
- `!g` asks for an outcome through achievement plans; `?p` asks whether information can be established.
- **B:** `lives` facts and the `local` rule. **D:** start. **I:** the start plan while executing its queries. There is no belief-change reactive plan here.
