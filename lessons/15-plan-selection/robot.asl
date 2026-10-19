route(stairs).

!start.
+!start <- !deliver(alice); -+route(elevator); !deliver(bob).

@by_elevator +!deliver(C) : route(elevator) <- .print("Elevator delivery: ",C).

@by_stairs +!deliver(C) : route(stairs) <- .print("Stairs delivery: ",C).
