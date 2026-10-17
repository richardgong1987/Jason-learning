!start.
+!start <- !inspect(parcel(alice,book,2));
           Pair = pair(tokyo,osaka);
           Pair = pair(From,To);
           .print("Route: ",From," -> ",To).
+!inspect(parcel(Customer,Item,Count))
    <- .print("Parcel: ",Customer," / ",Item," / ",Count).
