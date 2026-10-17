authorized.
!start.
+!start <- !!work;
           .wait(50);
           .suspend(work);
           .print("Work suspended");
           -authorized;
           .resume(work);
           .print("Work resumed").
+!work <- .wait(300); !commit.
+!commit : authorized <- .print("Command accepted").
+!commit : not authorized <- .print("Command blocked after recheck").
