{ include("shared.asl") }
stock::available(book).
shipping::available(van).
!start.
+!start <- !greet;
           ?stock::available(Item);
           ?shipping::available(Vehicle);
           .print("Stock item: ",Item);
           .print("Shipping vehicle: ",Vehicle).
