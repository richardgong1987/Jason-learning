// An arbitrary classroom threshold, not a trading recommendation.
max_spread_ticks(5).

+!review(Id, Symbol, Side, Spread, Mode)[source(coordinator)]
    : max_spread_ticks(Max) & Spread <= Max
    <- .print("APPROVED ", Id);
       .send(execution, achieve, place(Id, Symbol, Side, Mode)).

+!review(Id, Symbol, Side, Spread, Mode)[source(coordinator)]
    : max_spread_ticks(Max) & Spread > Max
    <- .print("REJECTED ", Id, " spread too wide");
       .send(coordinator, tell, outcome(Id, rejected)).
