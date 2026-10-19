# Lesson 31 — Graduation capstone: two firefighters, competing fires

You have learned Jason's syntax. Now use it to answer a system-level question:

> When two autonomous agents know about the same emergency, who commits to it, and what changes when a more urgent emergency appears?

This runnable project uses three agents: `dispatcher`, `alpha`, and `bravo`. It is a small **Contract Net-inspired allocation protocol**: request bids, evaluate proposals, award work, receive acceptance, deploy, and confirm completion. It is not a full implementation of the FIPA Contract Net specification.

Coordination is an important application of multiagent systems, not their only purpose. The intelligence here is explicit reasoning over beliefs, constraints, priorities, and commitments. There is no LLM, learning model, or magic built-in firefighter allocator.

## Run it

From the repository root, using the same Java 21 / Jason 3.3.0 setup as the earlier lessons:

```bash
cd lessons/31-firefighter-coordination
jason main.mas2j
```

No Java source needs compiling in this lesson. Jason normally stays alive after the demonstration; stop it before rerunning.

For automated checks, from the repository root:

```bash
export JASON_CLASSPATH="/absolute/path/to/jason/lib/*"
python3 scripts/run_checks.py --lesson 31 --seconds 6
python3 scripts/check_firefighters.py
```

The second checker runs changed scenarios in temporary copies. It never edits your lesson files.

## 1. Predict the problem before reading the solution

Each firefighter has a private belief base:

| Agent | Water | Distance to warehouse | Distance to hospital |
| --- | ---: | ---: | ---: |
| alpha | 10 | 2 | 1 |
| bravo | 10 | 4 | 8 |

Fire data:

| Fire | Priority | Water required |
| --- | ---: | ---: |
| warehouse | 2 | 3 |
| hospital | 10 | 4 |

Higher priority means greater urgency. Distances are abstract travel costs, not wall-clock seconds.

Initially only the warehouse fire is known to the dispatcher. Both firefighters learn about it through a call for proposals. Alpha wins because its distance is smaller. **Bravo knowing about the fire does not authorize Bravo to act.**

After Alpha accepts the warehouse reservation, a hospital fire arrives. The dispatcher must reconsider the unstarted commitment. Otherwise Alpha would remain occupied by the lower-priority warehouse while the much farther Bravo served the hospital.

Predict the final allocation before running the code.

## 2. Follow the actual message conversation

| Step | Sender → receiver | Message content and effect |
| --- | --- | --- |
| 1 | Dispatcher → both | `achieve, cfp(1,warehouse,3)` requests bids |
| 2 | Both → dispatcher | `tell, bid(1,warehouse,Cost)` reports local cost or `-1` for ineligible |
| 3 | Dispatcher → alpha | `achieve, award(1,warehouse,3)` offers a reservation |
| 4 | Alpha → dispatcher | `tell, accepted(1,warehouse)` confirms commitment |
| 5 | Scenario fixture | Hospital fire arrives before deployment |
| 6 | Dispatcher → alpha | `achieve, release(1,warehouse)` requests cancellation |
| 7 | Alpha → dispatcher | `tell, released(1,warehouse)` confirms release |
| 8 | Dispatcher → both | Round 2 asks for hospital bids; Alpha wins and accepts |
| 9 | Dispatcher → both | Round 3 asks for warehouse bids; Alpha declines because it is reserved; Bravo wins |
| 10 | Dispatcher → winners | `achieve, deploy(Round,Fire)` starts simulated work |
| 11 | Winners → dispatcher | `tell, done(Round,Fire)` confirms completion |

`cfp`, `bid`, `award`, and `release` are our own message-content names. They are **not** additional `.send` performatives. The performatives here are `achieve` and `tell`.

A bid is not an assignment. An award is not proof of acceptance. Acceptance is not proof of completion. Each transition has its own evidence.

Both proposals are collected before comparing costs: the fastest message is not automatically the best bid. Ties are broken deterministically by the agent atom through sorting `candidate(Cost,Agent)` terms.

## 3. Translate the decisions into mathematics

Let:

- $A = \{alpha, bravo\}$ be the firefighter set.
- $F$ be the known fires.
- $w_a$ be agent $a$'s water, and $n_f$ the water needed for fire $f$.
- $d(a,f)$ be travel cost, and $p_f$ be fire priority.
- $x_{a,f}\in\{0,1\}$ indicate an accepted assignment.

An agent may hold at most one active reservation:

$$\forall a\in A:\quad \sum_{f\in F} x_{a,f}\leq 1$$

Each fire in this exercise requires one firefighter:

$$\forall f\in F:\quad \sum_{a\in A}x_{a,f}\leq 1$$

The set of eligible bidders is:

$$E_f=\{a\in A\mid a\text{ is free}\land w_a\geq n_f\}$$

Read $\mid$ as “such that” and $\land$ as “and”.

The dispatcher processes fires in descending priority and chooses:

$$a^*(f)=\operatorname*{arg\,min}_{a\in E_f}d(a,f)$$

Here `arg min` means **the agent that achieves the smallest cost**, not the cost itself. If $E_f=\varnothing$, there is no eligible agent; the demonstration stops without claiming success.

For the initial warehouse auction:

$$d(alpha,warehouse)=2<4=d(bravo,warehouse)$$

So Alpha is reserved. After cancellation is acknowledged, the hospital is considered first:

$$p_{hospital}=10>2=p_{warehouse}$$

$$d(alpha,hospital)=1<8=d(bravo,hospital)$$

Alpha takes the hospital. Alpha is now unavailable for the next auction, so Bravo takes the warehouse.

The final travel-cost sum is $1+4=5$. Keeping the original warehouse reservation would give $2+8=10$ in this particular example.

**The implemented policy is priority-first greedy allocation, not a general globally optimal matching algorithm.** For other distance matrices it can produce a worse total cost than joint optimisation. The code also does not continuously optimise while work is underway.

## 4. Read the source in this order

1. [`main.mas2j`](main.mas2j): declares the three agents. Declaration order does not control their execution order.
2. [`alpha.asl`](alpha.asl) and [`bravo.asl`](bravo.asl): private capabilities and distances; both include the same plan library.
3. [`firefighter.asl`](firefighter.asl): quote, reserve, release, deploy, and finish plans.
4. [`dispatcher.asl`](dispatcher.asl): staged scenario and allocation protocol.

These are the complete runnable sources, not pseudocode. Start by tracing a single `cfp` message through the matching plan before reading the whole dispatcher.

### Eligibility is local reasoning

```asl
not assigned(_,_,_) & water(W) & W >= Need & distance(F,D)
```

This asks whether the agent is free, knows its water level, has enough water, and knows a distance to this fire. `Need` comes from the request; `W` and `D` come from the receiver's own beliefs. The dispatcher does not read another agent's private belief base directly.

The receiver replies with `bid(R,F,D)` or `bid(R,F,-1)`. In this teaching protocol all valid costs must be nonnegative; `-1` is a sentinel for refusal.

### Priorities become an ordered list

```asl
.findall(job(Key,F), (fire(F,P,_) & Key = -P),Jobs);
.sort(Jobs,Ordered);
```

For the default facts, this constructs and sorts:

$$[job(-2,warehouse),job(-10,hospital)]$$

into:

$$[job(-10,hospital),job(-2,warehouse)]$$

Sorting ascending on negative priority makes the largest positive priority come first. Equal priorities are ordered by fire atom.

### Replies must belong to the right conversation

```asl
.wait((bid(R,F,_)[source(alpha)] & bid(R,F,_)[source(bravo)]),3000)
```

The dispatcher waits for both sources for the **same round and fire**. The condition works even if a reply arrived before the wait. The timeout is 3,000 milliseconds. A missing bid fails the current allocation rather than silently treating silence as agreement.

Old bids can remain in the belief base because a fresh round number separates conversations. A long-running service would also need retention and cleanup rules.

### Atomic reservation is a local invariant

`@reserve[atomic]` keeps the eligibility recheck and insertion of `assigned(R,F,Need)` together within that firefighter's intention execution. Another local intention cannot slip between these steps. It is not a distributed transaction or a lock over all agents.

### Cancellation requires acknowledgement

The dispatcher first requests release, then waits for `released(...)`, then removes its local `allocation(...)` record. Sending cancellation alone does not establish that a worker has stopped.

The firefighter refuses release after `started(R,F)` exists. This project only reallocates **accepted but unstarted** work. Interrupting active firefighting requires additional state, safe stopping, partial progress, and a separate protocol.

### Duplicate and stale commands are deliberate

The dispatcher sends the cancelled round-1 deployment and sends each valid deployment twice. A deployment starts only if the matching reservation still exists and `started(R,F)` does not. Atomic check-and-mark ensures one work intention is launched per reservation in this running process.

The round-1 command is stale and cannot match the new assignment. Retained `started` facts prevent a duplicate deployment from starting the same work again. This is not a crash-proof, persistent exactly-once guarantee. Repeated awards and coordinator restarts are outside this version's protocol.

## 5. Where are B, D, I, and reactive behaviour?

| Concept | Concrete example |
| --- | --- |
| Beliefs | `water(10)`, `distance(hospital,1)`, `assigned(2,hospital,4)` |
| Goals | `!allocate(...)`, received `!cfp(...)`, received `!deploy(...)` |
| Plans | The definitions headed by `+!cfp`, `+!award`, and `+!work` |
| Intentions | The selected, instantiated execution of those plans |
| Reactive behaviour | Responding to incoming messages; waking a suspended condition wait when replies become available |
| Deliberation | Checking eligibility, comparing proposals, and reconsidering the warehouse reservation |

The supplied hospital arrival is injected by the dispatcher immediately after the first acceptance. This makes the lesson repeatable without a fragile sleep-based arrival race. Adding the `fire` belief alone does not trigger replanning in this version: the scenario's `!start` plan explicitly performs it. Turning arrivals into independent environment events is a graduation extension below.

## 6. Expected observations

Look for these milestones; individual agents' bid and work logs may interleave:

```text
INITIAL warehouse -> alpha
NEW FIRE hospital: reconsider unstarted commitments
CANCELLATION CONFIRMED before reallocation
FINAL hospital -> alpha
FINAL warehouse -> bravo
CAPSTONE COMPLETE: both fires handled once
```

You should see exactly one `EXTINGUISHED` for round 2 / hospital and one for round 3 / warehouse. There must be no `EXECUTING round=1`. The release acknowledgement must precede the new awards. At the end Alpha has 6 water and Bravo has 7.

For debugging, inspect `assigned`, `started`, `bid`, `allocation`, and `done` in the Mind Inspector. The dispatcher may be suspended in a condition wait while firefighters continue running.

If coordination times out or finds no eligible agent, look for `COORDINATION STOPPED`. Earlier reservations may still exist: this is a fail-closed teaching demonstration, not automatic rollback. Stop/restart the MAS after a failed experiment; do not assume all resources have been released.

## 7. Your graduation exercises

First run and understand the reference solution. Then change one policy at a time and record a predicted trace, actual trace, and explanation.

1. **Capability beats proximity.** Change Alpha's `water(10)` to `water(3)`. Predict both allocations.
2. **Priority changes decisions.** Change hospital priority from 10 to 1. Predict which fire is auctioned first after release.
3. **Insufficient resources.** Give both agents 2 water. The system must report no eligible firefighter and never claim completion.
4. **Explain a counterexample to greedy optimisation.** Try warehouse distances Alpha=1, Bravo=100 and hospital distances Alpha=2, Bravo=3. Compare priority-first greedy cost with the best complete matching. Is minimum total distance your real objective, or earliest response to the hospital?
5. **Independent arrivals.** Move fire generation into a Java environment or a separate incident agent. Serialize dispatcher allocation rounds so two arrival events cannot double-book an agent. Specify what happens if an arrival occurs during bidding, reservation, and deployment.
6. **Three fires, two firefighters.** Maintain a pending queue. When a completion arrives, auction the highest-priority feasible pending fire. Never forget the third fire or assign a busy worker.
7. **Recovery protocol.** Add a missing-reply scenario, bounded retries, duplicate-safe awards, and reconciliation of uncertain reservations. Explain why timeout does not prove cancellation.
8. **Active interruption (advanced).** Allow safe cancellation after deployment, require a stopped acknowledgement, and preserve partial work. Do not simply delete a belief and assume a physical action stopped.

<details>
<summary>Answers for the first three experiments</summary>

1. Alpha can reserve the warehouse initially but cannot bid for the hospital. After release, Bravo gets the hospital; Alpha gets the warehouse.
2. Warehouse goes first and Alpha wins; Bravo then gets the hospital. The current scenario still performs the teaching release/reauction sequence even when the new fire has lower priority.
3. No eligible bids exist in the first round. Allocation fails and the parent failure plan reports coordination stopped. Neither firefighter is deployed.

</details>

A successful graduation submission should include your protocol diagram, mathematical policy, trace evidence, a changed scenario, and a clear explanation of at least one limitation. Do not claim a feature is implemented just because it appears in this exercise list.

## 8. Explain it aloud

Two firefighters can know about the same fire without both committing to it. Each firefighter reasons about its own resources and sends a proposal. The dispatcher compares proposals and offers a reservation. The selected firefighter checks its resources again and acknowledges the assignment. When a more urgent fire appears, an unstarted reservation can be released, but the dispatcher waits for confirmation before reallocating the resource. Round identifiers distinguish old messages from current decisions. This system demonstrates explicit coordination, local reasoning, and revision of commitments. Its decisions follow the policy we programmed; it does not learn the policy by itself.

## Scope and references

The firefighting action is a short simulated wait followed by belief updates and a message. There is no external fire simulator proving the fire is out. Lesson 30 supplies the environment-action/percept pattern to add that boundary later. This runnable capstone is separate from the existing [trading integration roadmap](../../capstone/README.md).

- [Jason send documentation](https://jason-lang.github.io/api/jason/stdlib/send.html)
- [Jason wait documentation](https://jason-lang.github.io/api/jason/stdlib/wait.html)
- [Jason concurrency and atomic plans](https://jason-lang.github.io/jason/tech/concurrency.html)
- [Local verification record](VERIFICATION.md)
