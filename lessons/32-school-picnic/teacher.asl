participants(20).
forecast(rain).
member(alice).
member(ben).
member(chloe).

// A team-level constraint joins three independently proposed plans.
compatible(N,Weather,Food,Seats,Games) :-
    Food >= N & Seats >= N &
    (Weather == sunny | (Weather == rain & Games == indoor)).

!start.
+!start
    <- ?participants(N);
       ?forecast(Weather);
       .print("REQUIREMENTS people=",N," weather=",Weather);
       for (member(A)) { .send(A,achieve,survey(1)); };
       !collect(1,Food1,Seats1,Games1);
       .print("INITIAL food=",Food1," seats=",Seats1," games=",Games1);
       if (compatible(N,Weather,Food1,Seats1,Games1)) {
           .print("INITIAL plans happen to be compatible");
       } else {
           .print("MISMATCH: individually useful plans do not form a valid team plan");
           if (Food1 < N) { .print("CONFLICT insufficient meals"); };
           if (Seats1 < N) { .print("CONFLICT insufficient transport seats"); };
           if (Weather == rain & Games1 == outdoor) { .print("CONFLICT outdoor games in rain"); };
       };
       // Share one requirement snapshot; ask each role to reason again.
       for (member(A)) { .send(A,achieve,revise(2,N,Weather)); };
       !collect(2,Food2,Seats2,Games2);
       ?compatible(N,Weather,Food2,Seats2,Games2);
       .print("VALIDATED v=2 food=",Food2," seats=",Seats2," games=",Games2);
       .send(alice,achieve,commit(2,food(Food2)));
       .send(ben,achieve,commit(2,games(Games2)));
       .send(chloe,achieve,commit(2,transport(Seats2)));
       !await_ready(alice,food(Food2));
       !await_ready(ben,games(Games2));
       !await_ready(chloe,transport(Seats2));
       .print("ALL READY v=2: execution is now authorized");
       // Deliberate old-version and duplicate commands test local guards.
       for (member(A)) {
           .send(A,achieve,execute(1));
           .send(A,achieve,execute(2));
           .send(A,achieve,execute(2));
       };
       .wait((done(2,food(Food2))[source(alice)] &
              done(2,games(Games2))[source(ben)] &
              done(2,transport(Seats2))[source(chloe)]),3000);
       .print("PICNIC READY: meals, transport, and games agree").

+!collect(V,Food,Seats,Games)
    <- for (member(A)) {
           .wait((proposal(V,_)[source(A)] | refused(V,_)[source(A)]),3000);
       };
       if (refused(V,Reason)[source(Who)]) {
           .print("REVISION REFUSED v=",V," by=",Who," reason=",Reason);
           .fail;
       };
       ?proposal(V,food(Food))[source(alice)];
       ?proposal(V,transport(Seats))[source(chloe)];
       ?proposal(V,games(Games))[source(ben)].

+!await_ready(A,P)
    <- .wait((ready(2,P)[source(A)] | commit_refused(2,P)[source(A)]),3000);
       ?ready(2,P)[source(A)].

-!start <- .print("PICNIC BLOCKED: no team success; inspect constraints or missing acknowledgements").
