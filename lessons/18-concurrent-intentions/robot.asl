!start.
+!start <- !sequential;
           !!background;
           .print("Foreground continues").
+!sequential <- .print("Sequential subgoal completed").
+!background <- .wait(100); .print("Background completed").
