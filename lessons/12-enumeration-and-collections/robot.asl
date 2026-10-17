order(alice,book).
order(alice,pen).
order(bob,bag).
!start.
+!start <- for (order(Customer,Item)) {
               .print("Order: ",Customer," / ",Item);
           };
           .findall(C,order(C,_),Customers);
           .setof(C,order(C,_),Unique);
           .count(order(_,_),N);
           .sort(Customers,Sorted);
           .print("All customers: ",Sorted);
           .print("Unique customers: ",Unique);
           .print("Order count: ",N).
