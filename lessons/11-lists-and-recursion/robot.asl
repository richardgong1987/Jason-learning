!start.
+!start <- Items = [book,pen,bag];
           .length(Items,N);
           .print("Items: ",N);
           !pack(Items).
+!pack([]) <- .print("Packing complete").
+!pack([Head|Tail]) <- .print("Pack: ",Head); !pack(Tail).
