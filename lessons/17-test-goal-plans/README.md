# Lesson 17: Supplying missing information with test-goal plans

## The situation

The robot first checks its cached location. When the information is absent, a test-goal plan supplies a value.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/17-test-goal-plans
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
location(alice,tokyo).
!start.
+!start <- ?location(alice,A); .print("Cached location: ",A);
           ?location(bob,B); .print("Obtained location: ",B).
+?location(bob,City)
    <- .print("Looking up Bob"); City = osaka; +location(bob,City).
```

## How it works

- `?location(alice,A)` succeeds directly against a stored fact, so no test-goal plan is needed.
- When the Bob query has no answer, `+?location(bob,City)` provides a method for establishing it. Binding `City` supplies the result back to the caller.
- The added fact caches the answer for later queries. This lookup is a deterministic local simulation, not a network call.
- **B:** cached locations. **D:** start; the tests request information. **I:** the start plan with a test-goal plan pushed when necessary. Do not confuse `+?p` with the achievement trigger `+!p`.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Cached location: tokyo
Looking up Bob
Obtained location: osaka
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Query Bob twice. How many lookup messages appear?
2. Delete the cache insertion and run the two queries again.

<details>
<summary>Hints and answers — predict first</summary>

The cache causes one lookup. Without adding the belief each separate query invokes the test-goal plan again.

</details>

## Explain it aloud

The robot first checks its cached location. When the information is absent, a test-goal plan supplies a value. - `?location(alice,A)` succeeds directly against a stored fact, so no test-goal plan is needed.
- When the Bob query has no answer, `+?location(bob,City)` provides a method for establishing it. Binding `City` supplies the result back to the caller.
- The added fact caches the answer for later queries. This lookup is a deterministic local simulation, not a network call.
- **B:** cached locations. **D:** start; the tests request information. **I:** the start plan with a test-goal plan pushed when necessary. Do not confuse `+?p` with the achievement trigger `+!p`.
