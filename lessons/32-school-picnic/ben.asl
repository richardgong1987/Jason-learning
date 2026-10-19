initial_plan(games(outdoor)).
{ include("participant.asl") }

+!revise(V,N,rain)[source(teacher)] <- !offer(V,games(indoor)).
+!revise(V,N,sunny)[source(teacher)] <- !offer(V,games(outdoor)).
