remaining(3).
!start.
+!start <- while (remaining(N) & N > 0) {
               .print("Remaining: ",N);
               Next = N - 1;
               -remaining(N);
               +remaining(Next);
           };
           if (remaining(0)) { .print("All work finished"); };
           !countdown(2).
+!countdown(0) <- .print("Recursive countdown finished").
+!countdown(N) : N > 0 <- .print("Countdown: ",N); Next = N - 1; !countdown(Next).
