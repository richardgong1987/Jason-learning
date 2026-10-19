# Syntax-to-Example Index

Use this as a lookup, then read and run the linked lesson. These examples target Jason 3.3.0. See the [learning path](LEARNING_PATH.md) for the recommended order and the [verification report](VERIFICATION.md) for what was executed.

| Concept | Syntax or API | Runnable example |
| --- | --- | --- |
| Atoms, strings, numbers, structures | `alice`, `"Alice"`, `2`, `parcel(alice,2)` | [Lesson 07](../lessons/07-terms-and-unification/README.md) |
| Variables and anonymous variables | `Customer`, `_` | [Lesson 07](../lessons/07-terms-and-unification/README.md) |
| Unification / structure patterns | `Pair = pair(From,To)` | [Lesson 07](../lessons/07-terms-and-unification/README.md) |
| Initial beliefs / initial achievement goals | `p(a).`, `!start.` | [Lesson 07](../lessons/07-terms-and-unification/README.md) |
| Rules and test goals | `local(C) :- lives(C,tokyo).`, `?local(C)` | [Lesson 08](../lessons/08-queries-and-rules/README.md) |
| AND, OR, grouped conditions | `&`, `\|`, `( ... )` | [Lesson 09](../lessons/09-negation-and-contexts/README.md) |
| Strong negation / negation as failure | `~permit(C)`, `not permit(C)` | [Lesson 09](../lessons/09-negation-and-contexts/README.md) |
| Arithmetic and comparisons | `Total = Price * 3 + 2`, `>=`, `<`, `==`, `\==` | [Lesson 10](../lessons/10-arithmetic-and-comparisons/README.md) |
| Lists and head/tail patterns | `[]`, `[a,b]`, `[Head\|Tail]` | [Lesson 11](../lessons/11-lists-and-recursion/README.md) |
| Recursive goals and base cases | `!pack(Tail)` | [Lesson 11](../lessons/11-lists-and-recursion/README.md) |
| Enumerate query solutions | `for (Query) { Body }` | [Lesson 12](../lessons/12-enumeration-and-collections/README.md) |
| Collect, deduplicate, count, sort | `.findall`, `.setof`, `.count`, `.sort` | [Lesson 12](../lessons/12-enumeration-and-collections/README.md) |
| Belief addition, deletion, replacement | `+p`, `-p`, `-+p` | [Lesson 13](../lessons/13-belief-lifecycle/README.md) |
| Belief-addition / deletion triggers | `+p <- ...`, `-p <- ...` | [Lesson 13](../lessons/13-belief-lifecycle/README.md) |
| Remove all matching beliefs | `.abolish(task(_))` | [Lesson 13](../lessons/13-belief-lifecycle/README.md) |
| Conditional and loop constructs | `if (...) {...} else {...}`, `while (...) {...}` | [Lesson 14](../lessons/14-loops/README.md) |
| Plan trigger, context, body and label | `@label +!g : condition <- steps.` | [Lesson 15](../lessons/15-plan-selection/README.md) |
| Failure handling and explicit failure | `-!g`, `.fail` | [Lesson 16](../lessons/16-failure-and-retry/README.md) |
| Test-goal plans | `+?location(bob,City)` | [Lesson 17](../lessons/17-test-goal-plans/README.md) |
| Subgoal versus new intention | `!g` versus `!!g` | [Lesson 18](../lessons/18-concurrent-intentions/README.md) |
| Wait for time, a condition, or an event | `.wait(100)`, `.wait(ready,1000)`, `.wait({+p},1000)` | [Lesson 19](../lessons/19-waiting-and-timeouts/README.md) |
| Inspect/cancel intentions | `.intend(g)`, `.drop_intention(g)` | [Lesson 20](../lessons/20-cancelling-intentions/README.md) |
| Pause / resume | `.suspend(g)`, `.resume(g)` | [Lesson 21](../lessons/21-suspend-and-resume/README.md) |
| Literal annotations and source matching | `p[source(sensor),unit(celsius)]` | [Lesson 22](../lessons/22-annotations-and-provenance/README.md) |
| Message performatives and sender variables | `.send(...,tell,...)`, `untell`, `achieve`, `source(Sender)` | [Lesson 23](../lessons/23-tell-and-untell/README.md) |
| Remote synchronous information requests | `askOne`, `askAll`, answer and timeout arguments | [Lesson 24](../lessons/24-ask-one-and-all/README.md) |
| Plan annotations and local atomic execution | `@execute[atomic]` | [Lesson 25](../lessons/25-correlation-and-duplicates/README.md) |
| Correlation IDs and deduplication | `request(Id,Payload)`, `processed(Id)` | [Lesson 25](../lessons/25-correlation-and-duplicates/README.md) |
| Strings, term conversion, type checks | `.term2string`, `.concat`, `.upper_case`, `.number`, `.ground` | [Lesson 26](../lessons/26-strings-and-types/README.md) |
| Include directives and namespaces | `{ include("shared.asl") }`, `stock::available(book)` | [Lesson 27](../lessons/27-include-and-namespaces/README.md) |
| Runtime plan-library changes | `.add_plan`, `.remove_plan` | [Lesson 28](../lessons/28-dynamic-plan-library/README.md) |
| Custom Java internal actions | `demo.shipping_fee(Weight,Fee)` | [Lesson 29](../lessons/29-java-internal-action/README.md) |
| External environment actions / percepts | `open(door)`, `source(percept)` | [Lesson 30](../lessons/30-java-environment/README.md) |

## Reading punctuation

| Symbol | Meaning depends on position |
| --- | --- |
| `.` | Ends a belief, rule, initial goal, or complete plan; a leading dot also identifies a built-in standard internal action such as `.print` |
| `;` | Separates body steps; it also terminates declarations in a MAS configuration |
| `:` | Begins the context of a plan |
| `<-` | Begins the body of a plan |
| `:-` | Begins the body of a logical rule |
| `@` | Introduces a plan label |
| `[]` | A list in term position; annotations when attached after a literal or label |
| `{}` | A control-flow body, a directive, or an event term depending on context |
| `+` / `-` | Add/delete a belief in the body, or match addition/deletion events in the trigger |
| `!` / `?` | Achievement/test goal |

## Less common language constructs to explore next

The course deliberately keeps the main path small enough to reason about. The following are not claimed as covered runnable lessons:

- Univ/term decomposition (`=..`), variable predicates, explicit namespace directives, and advanced annotation unification.
- Plan/goal metadata annotations and Jason's advanced declarative goal patterns.
- Plan exchange (`tellHow`, `untellHow`, `askHow`) and agent/service lifecycle actions.
- Standard-library collection objects, random/time/math utilities, and file/console-specific helpers.
- Custom reasoning-cycle selection, infrastructure configuration, distributed execution, and alternative belief-base implementations.

Use the [official standard-library index](https://jason-lang.github.io/api/jason/stdlib/package-summary.html) for API-specific signatures. The interpreter's [official repository](https://github.com/jason-lang/jason) contains the grammar, tests, and larger examples. A complete library catalogue is different from mastering the core language; use focused experiments to learn an API when you need it.

## Integrated coordination example

[Lesson 31: firefighter capstone](../lessons/31-firefighter-coordination/README.md) combines sourced messages, round IDs, condition waits, atomic reservation, list sorting, resource constraints, and failure propagation in one runnable protocol.
