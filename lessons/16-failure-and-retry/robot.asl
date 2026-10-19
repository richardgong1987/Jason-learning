door(locked).
attempt(0).

!start.
+!start <- !open; .print("Parent continues after recovery").

+!open : door(locked) <- .print("Door locked: attempt fails"); .fail.

+!open : door(unlocked) <- .print("Door opened").

-!open : attempt(0)
    <- -+attempt(1); -+door(unlocked); !open.

-!open : attempt(1)
    <- .print("Retry exhausted"); .fail.
