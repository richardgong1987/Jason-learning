location(alice,tokyo).
!start.
+!start <- ?location(alice,A); .print("Cached location: ",A);
           ?location(bob,B); .print("Obtained location: ",B).
+?location(bob,City)
    <- .print("Looking up Bob"); City = osaka; +location(bob,City).
