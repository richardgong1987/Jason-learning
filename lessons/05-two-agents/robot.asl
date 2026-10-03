elevator(broken).

// No initial delivery goal: wait for a request from the manager.
+!deliver(Customer) : elevator(working)
    <- .print("Taking the elevator.");
       .print("Delivering food to ", Customer);
       +delivered(Customer);
       .send(manager, tell, delivered(Customer)).

+!deliver(Customer) : elevator(broken)
    <- .print("Taking the stairs.");
       .print("Delivering food to ", Customer);
       +delivered(Customer);
       .send(manager, tell, delivered(Customer)).
