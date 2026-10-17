!start.
+!start <- !!sensor;
           .wait(ready,1000);
           .print("Ready condition observed");
           !missing_event.
+!sensor <- .wait(50); +ready.
+!missing_event <- .wait({+never_arrives},50).
-!missing_event <- .print("Missing event timed out and was handled").
