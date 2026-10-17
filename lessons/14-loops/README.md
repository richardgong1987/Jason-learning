# Lesson 14: If, while, and recursive counters

## The situation

A robot counts down its remaining work. The counter is stored as a belief because logical variables are not mutable loop variables.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/14-loops
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
remaining(3).
!start.
+!start <- while (remaining(N) & N > 0) {
               .print("Remaining: ",N);
               Next = N - 1;
               -remaining(N);
               +remaining(Next);
           };
           if (remaining(0)) { .print("All work finished"); };
           !countdown(2).
+!countdown(0) <- .print("Recursive countdown finished").
+!countdown(N) : N > 0 <- .print("Countdown: ",N); Next = N - 1; !countdown(Next).
```

## How it works

- `while` reevaluates its condition each iteration; the body updates the belief so the loop eventually terminates.
- The variables used by each loop solution are handled by the control construct. Do not try to implement `N++` by unifying an already bound variable with a different number.
- The recursive alternative uses a decreasing argument and a base case. Both examples are sequential work inside an intention.
- **B:** remaining work. **D:** start and recursive countdown goals. **I:** the selected plans. A loop that neither changes its condition nor yields can run forever.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Remaining: 3
Remaining: 2
Remaining: 1
All work finished
Countdown: 2
Countdown: 1
Recursive countdown finished
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Start remaining work at zero.
2. Remove the belief update only as a thought experiment: why would termination disappear?

<details>
<summary>Hints and answers — predict first</summary>

Zero skips the while body. Without an update the condition stays true. Do not run an unbounded busy loop to wait for outside information; use `.wait` (Lesson 19).

</details>

## Explain it aloud

A robot counts down its remaining work. The counter is stored as a belief because logical variables are not mutable loop variables. - `while` reevaluates its condition each iteration; the body updates the belief so the loop eventually terminates.
- The variables used by each loop solution are handled by the control construct. Do not try to implement `N++` by unifying an already bound variable with a different number.
- The recursive alternative uses a decreasing argument and a base case. Both examples are sequential work inside an intention.
- **B:** remaining work. **D:** start and recursive countdown goals. **I:** the selected plans. A loop that neither changes its condition nor yields can run forever.
