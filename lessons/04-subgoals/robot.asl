battery(low).

!deliver(alice).

+!deliver(Customer)
    <- .print("Preparing the delivery.");
       !prepare;
       .print("Delivering food to ", Customer);
       +delivered(Customer).

+!prepare : battery(low)
    <- .print("Battery is low. Charging first.");
       -battery(low);
       +battery(full);
       .print("Battery is full.").

+!prepare : battery(full)
    <- .print("Battery is already full.").

+delivered(Customer)
    <- .print("Delivery completed for ", Customer).
