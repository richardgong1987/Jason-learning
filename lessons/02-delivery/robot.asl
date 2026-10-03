// Keep exactly one elevator state.
elevator(broken).

!deliver(alice).

+!deliver(Customer) : elevator(working)
    <- .print("Taking the elevator.");
       .print("Delivering food to ", Customer);
       +delivered(Customer).

+!deliver(Customer) : elevator(broken)
    <- .print("Taking the stairs.");
       .print("Delivering food to ", Customer);
       +delivered(Customer).
