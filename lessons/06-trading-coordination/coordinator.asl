// Scenario inputs: id, side, simulated spread in ticks, execution mode.
scenario(accepted_trade, buy, 2, normal).
scenario(rejected_trade, buy, 12, normal).
scenario(uncertain_trade, sell, 2, timeout).
next_case(accepted_trade, rejected_trade).
next_case(rejected_trade, uncertain_trade).

!run_case(accepted_trade).

+!run_case(Id) : scenario(Id, Side, Spread, Mode)
    <- .print("START ", Id);
       .send(analyst, achieve, analyse(Id, Side, Spread, Mode)).

+signal(Id, Symbol, Side, Spread, Mode)[source(analyst)]
    <- .print("SIGNAL ", Id, " from analyst");
       .send(risk, achieve, review(Id, Symbol, Side, Spread, Mode)).

+outcome(Id, Status)[source(risk)] : not terminal(Id)
    <- +terminal(Id);
       .print("RESULT ", Id, " ", Status);
       !advance(Id).

+outcome(Id, Status)[source(execution)] : not terminal(Id)
    <- +terminal(Id);
       .print("RESULT ", Id, " ", Status);
       !advance(Id).

+!advance(uncertain_trade)
    <- .print("All paper scenarios complete. No broker was contacted.").

+!advance(Id) : next_case(Id, Next)
    <- !run_case(Next).
