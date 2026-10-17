price(book,12).
count(0).
!start.
+!start <- ?price(book,Price);
           Total = Price * 3 + 2;
           .print("Invoice total: ",Total);
           if (Total >= 30) { .print("Large order"); }
           else { .print("Small order"); };
           ?count(Old);
           New = Old + 1;
           -+count(New);
           .print("Counter: ",New).
