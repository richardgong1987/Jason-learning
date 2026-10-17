# Lesson 28: Adding and removing a plan at runtime

## The situation

A robot installs a small recipe while running, executes it, and removes it. This demonstrates a mutable plan library without accepting remote code.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/28-dynamic-plan-library
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
!start.
+!start <- .add_plan("@temporary +!wave <- .print(\"Dynamic wave\").");
           !wave;
           .remove_plan(temporary);
           .print("Temporary plan removed").
```

## How it works

- `.add_plan` parses a plan string and installs it in the agent's plan library. Escaped quotes belong inside the ASL string.
- The installed plan is labeled `temporary`; `.remove_plan(temporary)` removes that recipe from the library.
- Removing a recipe is different from cancelling a running intention that already selected it. Use intention-control actions for that purpose.
- **B:** none. **D:** wave. **I:** start with the dynamically available wave subplan. The runtime plan library is distinct from the belief base and the current intentions.
- This locally supplied plan is trusted tutorial code. Dynamic code loading needs a separate trust policy in real systems.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Dynamic wave
Temporary plan removed
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Call `!wave` again after removal and observe failure.
2. Add a `-!wave` recovery plan to report the missing recipe.

<details>
<summary>Hints and answers — predict first</summary>

After removal there is no applicable wave plan. A matching failure plan can handle the request without reinstalling the recipe.

</details>

## Explain it aloud

A robot installs a small recipe while running, executes it, and removes it. This demonstrates a mutable plan library without accepting remote code. - `.add_plan` parses a plan string and installs it in the agent's plan library. Escaped quotes belong inside the ASL string.
- The installed plan is labeled `temporary`; `.remove_plan(temporary)` removes that recipe from the library.
- Removing a recipe is different from cancelling a running intention that already selected it. Use intention-control actions for that purpose.
- **B:** none. **D:** wave. **I:** start with the dynamically available wave subplan. The runtime plan library is distinct from the belief base and the current intentions.
- This locally supplied plan is trusted tutorial code. Dynamic code loading needs a separate trust policy in real systems.
