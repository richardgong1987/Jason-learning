# Extended Learning Path

Keep lessons 01–06 as the original introductory tour. Then follow 07–30 in order to study the language systematically. You can also complete 01–04, then 07–22, before returning to the multiagent tour in 05–06 and continuing with 23–30. Lesson 06 is an integration preview, not a prerequisite for arithmetic or lists.

Each new lesson contains source, a separate MAS configuration, a small real-world analogy, syntax explanation, BDI/reactive mapping, expected observations, exercises with hidden hints, and a spoken-English practice paragraph.

| Lesson | Focus | Instructions |
| --- | --- | --- |
| 07 | Terms, variables, and unification | [Open lesson](../lessons/07-terms-and-unification/README.md) |
| 08 | Test goals and derived beliefs | [Open lesson](../lessons/08-queries-and-rules/README.md) |
| 09 | Conjunction, disjunction, and two kinds of negation | [Open lesson](../lessons/09-negation-and-contexts/README.md) |
| 10 | Arithmetic, comparisons, and changing numeric state | [Open lesson](../lessons/10-arithmetic-and-comparisons/README.md) |
| 11 | Lists, head/tail patterns, and recursion | [Open lesson](../lessons/11-lists-and-recursion/README.md) |
| 12 | Enumerating answers: for, findall, setof, count | [Open lesson](../lessons/12-enumeration-and-collections/README.md) |
| 13 | Belief addition, deletion, replacement, and events | [Open lesson](../lessons/13-belief-lifecycle/README.md) |
| 14 | If, while, and recursive counters | [Open lesson](../lessons/14-loops/README.md) |
| 15 | Relevant plans, applicable plans, and labels | [Open lesson](../lessons/15-plan-selection/README.md) |
| 16 | Goal failure, bounded retry, and recovery | [Open lesson](../lessons/16-failure-and-retry/README.md) |
| 17 | Supplying missing information with test-goal plans | [Open lesson](../lessons/17-test-goal-plans/README.md) |
| 18 | Subgoals versus new intentions: ! and !! | [Open lesson](../lessons/18-concurrent-intentions/README.md) |
| 19 | Waiting for conditions and handling timeouts | [Open lesson](../lessons/19-waiting-and-timeouts/README.md) |
| 20 | Inspecting and cancelling a background goal | [Open lesson](../lessons/20-cancelling-intentions/README.md) |
| 21 | Suspending, resuming, and rechecking beliefs | [Open lesson](../lessons/21-suspend-and-resume/README.md) |
| 22 | Belief annotations and source provenance | [Open lesson](../lessons/22-annotations-and-provenance/README.md) |
| 23 | Tell, untell, achieve, and sender-aware replies | [Open lesson](../lessons/23-tell-and-untell/README.md) |
| 24 | Remote queries with askOne and askAll | [Open lesson](../lessons/24-ask-one-and-all/README.md) |
| 25 | Request IDs and duplicate-message handling | [Open lesson](../lessons/25-correlation-and-duplicates/README.md) |
| 26 | Strings, term conversion, and type checks | [Open lesson](../lessons/26-strings-and-types/README.md) |
| 27 | Sharing source files and separating namespaces | [Open lesson](../lessons/27-include-and-namespaces/README.md) |
| 28 | Adding and removing a plan at runtime | [Open lesson](../lessons/28-dynamic-plan-library/README.md) |
| 29 | Writing a Java internal action | [Open lesson](../lessons/29-java-internal-action/README.md) |
| 30 | External actions and environment percepts | [Open lesson](../lessons/30-java-environment/README.md) |

## How to learn from each example

1. Identify the initial beliefs and goals before running it.
2. For every trigger, say what event makes it relevant and what context makes it applicable.
3. Predict the visible output and distinguish guaranteed sequencing from possible interleaving.
4. Run the unchanged example, then change one thing at a time.
5. Complete the exercises before opening the hints.
6. Explain which runtime plans become intentions and where failure can propagate.

## Milestone challenges

- **After 14:** build an inventory agent with multiple products, a list of orders, arithmetic totals, and a rule for low stock. Updating one product must preserve all other records.
- **After 17:** add a bounded retry for unavailable stock; exhausted retries must not print a success confirmation.
- **After 22:** run two jobs concurrently; pause one, change its authorization, resume it, and show that it checks permission before committing.
- **After 25:** build a manager/worker protocol with request IDs, replies, timeouts, duplicate detection, and detection of the same ID reused with a different payload.
- **After 30:** replace a printed simulation with a Java environment action and verify the result through a percept. Explain how action failure differs from missing confirmation.

Write these challenges yourself. Reusing a recipe is useful, but predict and explain its behavior before combining it with another feature.

## Scope of “all syntax and usage”

This path covers the major AgentSpeak/Jason language constructs and common programming patterns. It is not an exhaustive implementation of every standard-library action or infrastructure extension. Advanced follow-up topics include service discovery, agent creation/deletion, plan exchange (`tellHow`/`askHow`), custom agent selection functions, alternative belief bases, priorities/scheduling policies, Java sets/maps/queues, random/time functions, and distributed deployment. Consult the [official internal-action catalogue](https://jason-lang.github.io/api/jason/stdlib/package-summary.html) for the complete library, and add a focused experiment whenever a project needs one of those features.

The Java lessons introduce extension points; they do not implement Python, AI, broker, or physical-device adapters.
