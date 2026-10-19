battery(20).
task(old).

!start.
+!start <- +task(new);
           -task(old);
           -+battery(100);
           .abolish(task(_));
           ?battery(Level);
           .print("Final battery: ",Level).
+task(new) <- .print("Reactive: new task observed").
-task(old) <- .print("Reactive: old task removed").
