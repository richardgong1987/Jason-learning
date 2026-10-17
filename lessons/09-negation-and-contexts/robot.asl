permit(alice).
~permit(bob).
member(alice).
staff(carol).
!start.
+!start <- !check(alice); !check(bob); !check(carol).
+!check(C) : permit(C) & (member(C) | staff(C))
    <- .print("Allowed: ",C).
+!check(C) : ~permit(C)
    <- .print("Explicit denial: ",C).
+!check(C) : not permit(C) & not ~permit(C)
    <- .print("Unknown permission: ",C).
