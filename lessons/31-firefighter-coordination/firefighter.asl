// Local state is private. A bid is an offer, not an assignment.
@quote[atomic]
+!cfp(R,F,Need)[source(dispatcher)]
    <- if (not assigned(_,_,_) & water(W) & W >= Need & distance(F,D)) {
           .print("BID round=",R," fire=",F," cost=",D);
           .send(dispatcher,tell,bid(R,F,D));
       } else {
           .print("DECLINE round=",R," fire=",F);
           .send(dispatcher,tell,bid(R,F,-1));
       }.

// Recheck eligibility when the award arrives: an earlier bid is not a lock.
@reserve[atomic]
+!award(R,F,Need)[source(dispatcher)]
    <- if (not assigned(_,_,_) & water(W) & W >= Need) {
           +assigned(R,F,Need);
           .print("RESERVED round=",R," fire=",F);
           .send(dispatcher,tell,accepted(R,F));
       } else {
           .send(dispatcher,tell,refused(R,F));
       }.

// Release only a reservation that has NOT begun execution.
@release[atomic]
+!release(R,F)[source(dispatcher)]
    <- if (assigned(R,F,N) & not started(R,F)) {
           -assigned(R,F,N);
           .print("RELEASED round=",R," fire=",F);
           .send(dispatcher,tell,released(R,F));
       } else {
           .send(dispatcher,tell,release_refused(R,F));
       }.

// Check-and-mark is atomic; the longer work runs as a separate intention.
@deploy[atomic]
+!deploy(R,F)[source(dispatcher)]
    <- if (assigned(R,F,_) & not started(R,F)) {
           +started(R,F);
           !!work(R,F);
       } else {
           .print("IGNORED deploy round=",R," fire=",F);
       }.

+!work(R,F)
    <- .print("EXECUTING round=",R," fire=",F);
       .wait(100);
       !finish(R,F).

@finish[atomic]
+!finish(R,F) : assigned(R,F,Need) & water(W)
    <- Remaining = W - Need;
       -+water(Remaining);
       -assigned(R,F,Need);
       +completed(R,F);
       .print("EXTINGUISHED round=",R," fire=",F);
       .send(dispatcher,tell,done(R,F)).
