# Lesson 9: Conjunction, disjunction, and two kinds of negation

## The situation

An entry gate distinguishes an unknown permission from an explicitly denied permission. Missing information is not always evidence of the opposite.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/09-negation-and-contexts
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
permit(alice).
~permit(bob).
member(alice).
staff(carol).
!start.
+!start <- !check(alice); !check(bob); !check(carol).
+!check(C) : permit(C) & (member(C) | staff(C))
    <- .print("Allowed: ",C).
+!check(C) : ~permit(C)
    <- .print("Explicit denial: ",C).
+!check(C) : not permit(C) & not ~permit(C)
    <- .print("Unknown permission: ",C).
```

## How it works

- `&` means logical AND; `|` means logical OR. Parentheses make grouping explicit.
- `~permit(bob)` is strong negation: explicit negative information.
- `not permit(carol)` succeeds when the positive query cannot be proved. It also succeeds for Bob; it is not the same as having `~permit(carol)`.
- The last context checks that neither positive nor explicit negative permission is known. The supplied cases have disjoint contexts, so plan ordering is not needed to choose correctly.
- **B:** permissions, membership and staff facts. **D:** the checks. **I:** selected check plans. A context is tested when selecting a plan, not continuously throughout the body.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Allowed: alice
Explicit denial: bob
Unknown permission: carol
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Add `permit(carol).` and predict the new route.
2. Add both `permit(bob).` and `member(bob).` while retaining `~permit(bob).`. Explain why conflicting beliefs are dangerous.

<details>
<summary>Hints and answers — predict first</summary>

Carol becomes allowed. Contradictory positive and negative beliefs can coexist and make multiple plans applicable; strong negation is not automatic consistency enforcement.

</details>

## Explain it aloud

An entry gate distinguishes an unknown permission from an explicitly denied permission. Missing information is not always evidence of the opposite. - `&` means logical AND; `|` means logical OR. Parentheses make grouping explicit.
- `~permit(bob)` is strong negation: explicit negative information.
- `not permit(carol)` succeeds when the positive query cannot be proved. It also succeeds for Bob; it is not the same as having `~permit(carol)`.
- The last context checks that neither positive nor explicit negative permission is known. The supplied cases have disjoint contexts, so plan ordering is not needed to choose correctly.
- **B:** permissions, membership and staff facts. **D:** the checks. **I:** selected check plans. A context is tested when selecting a plan, not continuously throughout the body.
