!start.

+!start
    <- .print("Requesting delivery to alice.");
       .send(robot, achieve, deliver(alice)).

+delivered(Customer)[source(robot)]
    <- .print("Robot confirmed delivery to ", Customer).
