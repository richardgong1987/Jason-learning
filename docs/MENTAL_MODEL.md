# Understanding Jason Beyond Three Acronyms

## Beliefs, desires, intentions, and plans

A small vocabulary can produce complex behavior because bindings, event queues, plan selection, intention stacks, suspension, failure propagation, and inter-agent messages interact.

| Item | Meaning | Example | What to inspect |
| --- | --- | --- | --- |
| Belief | Information currently held; it can be wrong | `battery(low).` | Belief base, annotations, rules, current percepts |
| Goal / desire | An outcome being pursued or requested | `!deliver(alice)` | Pending events and active goal stacks |
| Plan | A recipe available for a matching event and context | `+!deliver(C) : ready <- ...` | Plan library; relevant/applicable options |
| Intention | The committed runtime execution of selected plans | Delivery plan with a preparation subplan | Intention stacks, bindings, suspended/waiting states |

Do not mark an entire source plan as **I** without qualification: the source declares a recipe. An intention arises when that recipe is instantiated and selected at runtime. Likewise, a `+!g` trigger describes how to respond to a goal event; it is not by itself a running goal request.

Initial `!g.` declarations introduce achievement goals. A body `!g` requests a subgoal inside the current intention; `!!g` launches a goal into a separate intention. A multiagent `.send(worker,achieve,g)` asks the receiver to pursue a goal; it does not wait for completion.

## What reactive means

A reactive plan responds to an event, for example a new `+temperature(high)` belief, a removed `-connected` belief, or a percept received from an environment. It may run alongside an already active goal-directed intention.

“Reactive” is not a fourth BDI data structure. A BDI agent can pursue a long-term delivery goal and also react to a low-battery event. Conversely, all Jason plan selection is event-driven, including achievement-goal events; the teaching distinction highlights responses to changing information rather than only top-down goal decomposition.

## A Java developer's common traps

| Tempting assumption | Actual behavior | Example |
| --- | --- | --- |
| `X = 3` is a mutable assignment | It unifies; an incompatible later binding fails | 07, 10 |
| `?p(X)` is a loop over all records | It establishes one solution for that test; use enumeration explicitly | 08, 12 |
| `not p` means a stored negative fact | It means the positive query cannot be proved; `~p` is explicit negation | 09 |
| `-+stock(book,N)` updates just that book | Replacement generalizes arguments and can remove other stock entries | 13 |
| A context is an always-active guard | It is checked during option selection; recheck before consequential work | 15, 21 |
| A second plan is an automatic catch/fallback | Body failure needs explicit goal-failure handling and retry policy | 16 |
| `!!g` is a normal synchronous method call | It creates work in a new intention and does not join it | 18 |
| Sleeping blocks the entire agent | `.wait` suspends its intention so other work can run | 18, 19 |
| Cancelling work undoes its effects | Already performed actions remain | 20 |
| Resuming a plan refreshes all its assumptions | The plan continues; a fresh subgoal can explicitly recheck state | 21 |
| `.send(...,achieve,...)` means the job finished | Completion needs a reply or observed result | 23, 25 |
| `untell` cancels another agent's work | It withdraws information attributed to the sender | 23 |
| A reply is only the inner variable value | `askOne` returns a literal; replies can carry source annotations | 24 |
| An atomic plan is a distributed transaction | It controls local intention interleaving and does not roll back external effects | 25 |
| `+door(open)` proves that a real door opened | A local belief change is only a local assertion; check environment feedback | 30 |

## Trace a program before running it

Write down the initial belief base, then the initial goal event. For each event, identify matching triggers, test contexts with the current bindings, and select a plan. Track body steps and the intention stack. Record any generated belief events, new intentions, messages, waits, or failures separately.

For concurrent programs, draw a partial order: steps within one intention are sequenced, but another intention may run between them. Do not invent a total print order unless the program establishes an actual dependency.

## Where complexity begins

When two requests update shared beliefs, a worker replies twice, a result arrives after a timeout, a previously authorized intention resumes, or an external action succeeds but its acknowledgement is lost, simple source syntax is no longer enough. You must design state transitions, correlation, commitment, and recovery. Lessons 18–30 introduce those questions with small observable examples.

## References

- [Official BDI tutorial](https://github.com/jason-lang/jason/blob/main/doc/tutorials/hello-bdi/readme.adoc)
- [Jason FAQ and failure semantics](https://jason-lang.github.io/jason/faq.html)
- [Internal-action catalogue](https://jason-lang.github.io/api/jason/stdlib/package-summary.html)
