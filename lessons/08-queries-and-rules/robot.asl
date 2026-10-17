lives(alice,tokyo).
lives(bob,osaka).
local(C) :- lives(C,tokyo).
!start.
+!start <- ?local(Customer);
           .print("Local customer: ",Customer);
           ?lives(bob,City);
           .print("Bob lives in ",City).
