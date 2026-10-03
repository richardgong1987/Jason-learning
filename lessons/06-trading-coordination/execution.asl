mode(paper).

+!place(Id, Symbol, Side, normal)[source(risk)] : mode(paper)
    <- .print("PAPER FILL ", Id, " ", Symbol, " ", Side);
       +paper_fill(Id);
       .send(coordinator, tell, outcome(Id, filled)).

+!place(Id, Symbol, Side, timeout)[source(risk)] : mode(paper)
    <- .print("SIMULATED timeout for ", Id);
       .fail.

// A missing acknowledgement does not establish whether a broker filled an order.
// This lesson reports uncertainty; broker reconciliation is a later milestone.
-!place(Id, Symbol, Side, Mode)
    <- .print("RECOVERY ", Id, " status unknown; reconciliation required");
       .send(coordinator, tell, outcome(Id, unknown)).
