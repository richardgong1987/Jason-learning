# Lesson 32 — School picnic: good individual plans are not enough

Imagine your teacher asks your class to organise a school picnic.

Alice buys food. Ben prepares games. Chloe arranges transport.

Each child can do a useful job. But that alone does not guarantee a successful picnic. Alice might buy food for twenty people while Chloe books transport for ten. Ben might prepare outdoor games without knowing that rain is expected.

**Good individual decisions do not automatically produce good teamwork.**

In this runnable example, these initial choices are proposals. The agents discover the conflicts before doing the simulated buying, booking, or preparation. The lesson is about **shared constraints and agreement**, whereas [Lesson 31](../31-firefighter-coordination/README.md) is about allocating competing jobs to scarce resources.

## Run it

From the repository root, with the [course setup](../../docs/SETUP.md):

```bash
cd lessons/32-school-picnic
jason main.mas2j
```

There are four agents: `teacher`, `alice`, `ben`, and `chloe`. No Java extension is required. Stop the MAS after observing the result; it normally remains alive waiting for events.

## First predict the failure

Only the teacher initially knows the authoritative requirement: **20 people, rain expected**.

| Participant | Private initial proposal | Why that alone is insufficient |
| --- | --- | --- |
| Alice | 20 meals | Meals do not prove enough transport exists |
| Ben | Outdoor games | Ben has not yet received the forecast |
| Chloe | 10 transport seats | Chloe has not yet received the group size |

No single participant can establish that the whole picnic is feasible merely by completing their own task.

## Translate teamwork into mathematics

Let:

- $N$ = number of participants.
- $F$ = number of meals.
- $S$ = number of transport seats.
- $W$ = forecast, either `rain` or `sunny` in this model.
- $G$ = game setting, either `indoor` or `outdoor`.

A valid team plan must satisfy all constraints together:

$$C(N,W,F,S,G)=(F\geq N)\land(S\geq N)\land\bigl((W=sunny)\lor(W=rain\land G=indoor)\bigr)$$

Read $\land$ as **and**, and $\lor$ as **or**. Under rain, games must be indoors. Under sunshine, either setting is acceptable. These are deliberately simplified rules for this classroom model.

With the original proposals:

$$N=20,\quad F=20,\quad S=10,\quad W=rain,\quad G=outdoor$$

The food condition holds, but:

$$10\not\geq20$$

and rainy weather is incompatible with outdoor games. Therefore:

$$C(20,rain,20,10,outdoor)=false$$

After communication and revision:

$$C(20,rain,20,20,indoor)=true$$

The constraint uses $F\geq N$ and $S\geq N$, not $F=S$: spare seats or meals are allowed. The agents happen to propose exactly $N$ in the revised plan.

A useful distinction is:

$$\text{Local task completion}\not\Rightarrow\text{Team goal achieved}$$

In this example, the teacher requires both a compatible plan and matching completion evidence from all three participants.

## Read the code in this order

1. [`main.mas2j`](main.mas2j): the four agent declarations.
2. [`alice.asl`](alice.asl), [`ben.asl`](ben.asl), [`chloe.asl`](chloe.asl): each role's beliefs and revision policy.
3. [`participant.asl`](participant.asl): the shared proposal, commitment, and execution protocol.
4. [`teacher.asl`](teacher.asl): the compatibility rule, conflict detection, and coordination sequence.

Including the same file does not create shared mutable memory. Each participant has its own beliefs and intentions.

## Trace the conversation

| Phase | Message | Meaning |
| --- | --- | --- |
| Survey | Teacher sends `achieve, survey(1)` | Tell me your current proposed contribution |
| Proposal | Participants send `tell, proposal(1,Plan)` | Here is my local plan |
| Diagnosis | Teacher evaluates `compatible(...)` | Do the three plans work together? |
| Revision | Teacher sends `achieve, revise(2,20,rain)` | Reconsider using this common requirement snapshot |
| New proposal | Participants send `proposal(2,Plan)` or `refused(2,Reason)` | Offer a feasible contribution or explain inability |
| Validation | Teacher evaluates the revised combination | Check compatibility before committing anyone |
| Commitment | Teacher sends `achieve, commit(2,Plan)` | Commit to the exact contribution you proposed |
| Readiness | Participants send `tell, ready(2,Plan)` | I have recorded this commitment |
| Execution | Teacher sends `achieve, execute(2)` | All participants are ready; perform your contribution |
| Completion | Participants send `tell, done(2,Plan)` | My simulated contribution is complete |

`survey`, `revise`, `commit`, and `execute` are names we defined. The actual message performatives remain `achieve` and `tell`.

This is **coordinator-led agreement**, not leaderless consensus or competitive bargaining. The participants reason locally and may refuse; the teacher checks the combined result.

## Where the reasoning happens

### Alice and Chloe check capability

Chloe's revision plan checks:

```asl
max_seats(Max) & N <= Max
```

Mathematically:

$$N\leq Capacity_{Chloe}$$

If it holds, Chloe proposes `transport(N)`. Otherwise, Chloe reports `insufficient_transport_capacity`. Sending a request does not give an agent unlimited resources.

Alice uses the same pattern for meal capacity.

### Ben chooses a context-appropriate plan

```asl
+!revise(V,N,rain)[source(teacher)] <- !offer(V,games(indoor)).
+!revise(V,N,sunny)[source(teacher)] <- !offer(V,games(outdoor)).
```

The received weather determines which plan matches. There is no probabilistic weather inference here: Ben applies an explicit policy to the shared forecast.

### The teacher reasons across roles

```asl
compatible(N,Weather,Food,Seats,Games) :-
    Food >= N & Seats >= N &
    (Weather == sunny | (Weather == rain & Games == indoor)).
```

This rule joins information from three distinct agents. A plan that is sensible in isolation may fail this combined condition.

### Version numbers keep conversations separate

`proposal(1,transport(10))` cannot satisfy a query for `proposal(2,transport(Seats))`. Old facts may remain in memory without contaminating the revised plan. Sourced queries also require food from Alice, games from Ben, and transport from Chloe.

The shared execution guard is:

```asl
committed(V,P) & not completed(V)
```

It requires the committed version and rejects repeated execution. The atomic plan keeps checking and recording completion together within one agent. The teacher deliberately sends an old-version command and duplicate valid commands to exercise this guard.

### Readiness is a barrier

The teacher sends execution messages only after all three exact commitments are acknowledged. A proposal alone is insufficient. A readiness message for another version or another plan is insufficient.

This does not make actions across different agents simultaneous or transactional. A participant could fail after others have acted; compensation and durable recovery would need another protocol.

## BDI mapping

| Concept | Example |
| --- | --- |
| Beliefs | `max_seats(30)`, `forecast(rain)`, `proposed(2,games(indoor))` |
| Goals | Survey the roles, revise contributions, commit, execute |
| Plans | Alternative Ben revision plans; capacity-aware Alice and Chloe plans |
| Intentions | Runtime executions of the selected plans |
| Reactive behaviour | Handling incoming requests and waking waits when replies arrive |
| Team reasoning | Checking a constraint that spans food, transport, and games |

The code implements policies you can inspect and change. It does not learn them automatically.

## Expected observations

```text
INITIAL food=20 seats=10 games=outdoor
MISMATCH: individually useful plans do not form a valid team plan
CONFLICT insufficient transport seats
CONFLICT outdoor games in rain
VALIDATED v=2 food=20 seats=20 games=indoor
ALL READY v=2: execution is now authorized
PICNIC READY: meals, transport, and games agree
```

Participant messages may interleave. Each participant must print `EXECUTED v=2` exactly once. Nobody should print `EXECUTED v=1`, and no execution should appear before `ALL READY v=2`.

Actual purchases, bookings, and games are simulated by logs, belief updates, and messages. `PICNIC READY` means the model's checks and confirmations succeeded; it does not establish that a real-world picnic has been organised.

## Change one thing and predict the result

1. Change `forecast(rain)` to `forecast(sunny)`. Which conflict disappears? What games does Ben propose?
2. Change `participants(20)` to `participants(12)`. Why does Alice revise her meals even though 20 would already be sufficient?
3. Change Chloe's `max_seats(30)` to `max_seats(10)`. The picnic must be blocked; nobody should execute their contribution.
4. Remove Chloe's `ready` reply. A proposal is still present, but the teacher must not authorize execution after the wait times out.
5. Add a total budget constraint. Each participant proposes both an outcome and a cost. Can all local costs be individually reasonable but collectively exceed the budget?
6. Add a weather update after readiness. Define how to invalidate the old version and gather fresh commitments before execution. Do not merely change the teacher's weather belief while leaving other agents on the old plan.
7. Model a booking failure after execution begins. Which completed actions need cancellation, refund, or a substitute plan?

<details>
<summary>Answers for the first four experiments</summary>

1. Outdoor games become acceptable, but transport is still too small initially. Ben keeps outdoor games in version 2.
2. Version 2 becomes 12 meals and 12 seats, with indoor games. Alice's simple policy is to supply exactly the requested number, even though the global constraint permits surplus.
3. Chloe refuses revision. The teacher reports `PICNIC BLOCKED`, and execution never starts.
4. The teacher cannot establish all three commitments. After the bounded wait it reports `PICNIC BLOCKED`; the earlier commitments are not automatically rolled back. Restart the MAS before another experiment.

</details>

## Explain it aloud

Alice, Ben, and Chloe can each perform a useful task, but useful individual actions do not guarantee a successful picnic. Their plans depend on shared facts such as group size and weather. The teacher collects their proposals and checks whether those proposals fit together. When a conflict appears, the teacher shares the requirements and asks for revised plans. Each participant checks its own abilities and either proposes a contribution or refuses. Only after the revised plan is valid and everyone acknowledges the same version does execution begin. Teamwork therefore requires communication, shared constraints, and evidence of commitment, not merely several agents working at the same time.

## Verification and limits

See [the verification record](VERIFICATION.md). The provided scenario has one fixed revision round, trusted agents, and a fixed requirement snapshot. It does not handle changing requirements during execution, repeated commitment requests, restarts, persistent deduplication, or automatic rollback. These are extensions, not hidden guarantees.

The example deliberately uses a teacher as coordinator so the coordination policy remains easy to trace. A central coordinator is not required by Jason itself.
