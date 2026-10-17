!start.
+!start <- !!work;
           .wait(50);
           if (.intend(work)) { .print("Work is intended"); };
           .drop_intention(work);
           .print("Work cancelled").
+!work <- .wait(1000); .print("UNEXPECTED: cancelled work completed").
