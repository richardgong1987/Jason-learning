// Shared protocol, separate beliefs in each participant.
+!survey(V)[source(teacher)] : initial_plan(P) <- !offer(V,P).

@offer[atomic]
+!offer(V,P)
    <- +proposed(V,P);
       .print("PROPOSAL v=",V," ",P);
       .send(teacher,tell,proposal(V,P)).

// Accept only a plan this participant actually offered for this version.
@commit[atomic]
+!commit(V,P)[source(teacher)]
    <- if (proposed(V,P) & not committed(_,_)) {
           +committed(V,P);
           .print("READY v=",V," ",P);
           .send(teacher,tell,ready(V,P));
       } else {
           .send(teacher,tell,commit_refused(V,P));
       }.

// A survey or proposal never authorizes buying/booking/preparing anything.
@execute[atomic]
+!execute(V)[source(teacher)]
    <- if (committed(V,P) & not completed(V)) {
           +completed(V);
           .print("EXECUTED v=",V," ",P);
           .send(teacher,tell,done(V,P));
       } else {
           .print("IGNORED execution v=",V);
       }.
