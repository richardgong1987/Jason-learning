// Scenario data: fire(Id, Priority, WaterNeeded). Higher priority wins.
fire(warehouse,2,3).
round(0).
!start.

+!start
    <- .print("PHASE 1: both firefighters learn about the warehouse");
       !allocate(warehouse,OldRound,OldWinner);
       .print("INITIAL warehouse -> ",OldWinner);
       // Deterministic arrival fixture: after acceptance, BEFORE deployment.
       +fire(hospital,10,4);
       .print("NEW FIRE hospital: reconsider unstarted commitments");
       .send(OldWinner,achieve,release(OldRound,warehouse));
       .wait((released(OldRound,warehouse)[source(OldWinner)] |
              release_refused(OldRound,warehouse)[source(OldWinner)]),3000);
       ?released(OldRound,warehouse)[source(OldWinner)];
       -allocation(OldRound,warehouse,OldWinner);
       .print("CANCELLATION CONFIRMED before reallocation");
       // Sort negative priorities ascending: highest priority comes first.
       .findall(job(Key,F), (fire(F,P,_) & Key = -P),Jobs);
       .sort(Jobs,Ordered);
       !allocate_all(Ordered);
       // Send a stale command and duplicate valid commands deliberately.
       .send(OldWinner,achieve,deploy(OldRound,warehouse));
       for (allocation(R,F,W)) {
           .send(W,achieve,deploy(R,F));
           .send(W,achieve,deploy(R,F));
       };
       !await_all(Ordered);
       .print("CAPSTONE COMPLETE: both fires handled once").

+!allocate_all([]).
+!allocate_all([job(_,F)|Rest])
    <- !allocate(F,R,W);
       .print("FINAL ",F," -> ",W);
       !allocate_all(Rest).

+!allocate(F,R,Winner)
    <- ?round(Previous);
       R = Previous + 1;
       -+round(R);
       ?fire(F,_,Need);
       .send(alpha,achieve,cfp(R,F,Need));
       .send(bravo,achieve,cfp(R,F,Need));
       // Condition waits also work when replies arrived before the wait.
       .wait((bid(R,F,_)[source(alpha)] & bid(R,F,_)[source(bravo)]),3000);
       .findall(candidate(C,W),
                (bid(R,F,C)[source(W)] & (W == alpha | W == bravo) & C >= 0),Candidates);
       .sort(Candidates,Ranked);
       !choose(Ranked,Winner);
       .print("AWARD round=",R," fire=",F," winner=",Winner);
       .send(Winner,achieve,award(R,F,Need));
       .wait((accepted(R,F)[source(Winner)] | refused(R,F)[source(Winner)]),3000);
       ?accepted(R,F)[source(Winner)];
       +allocation(R,F,Winner).

+!choose([candidate(_,W)|_],W).
+!choose([],_) <- .print("NO ELIGIBLE FIREFIGHTER"); .fail.

+!await_all([]).
+!await_all([job(_,F)|Rest])
    <- ?allocation(R,F,W);
       .wait(done(R,F)[source(W)],3000);
       .print("CONFIRMED ",F," by ",W);
       !await_all(Rest).

// Fail closed: a missing reply is not evidence that an old assignment is gone.
-!start <- .print("COORDINATION STOPPED: inspect missing reply, refusal, or capacity").
