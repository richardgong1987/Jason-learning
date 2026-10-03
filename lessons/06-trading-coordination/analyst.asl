// A deterministic fixture replaces Python and AI in this lesson.
+!analyse(Id, Side, Spread, Mode)[source(coordinator)]
    <- .print("FIXTURE analysis for ", Id);
       .send(coordinator, tell, signal(Id, eurusd, Side, Spread, Mode)).
