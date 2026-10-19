initial_plan(food(20)).
max_meals(30).
{ include("participant.asl") }

+!revise(V,N,Weather)[source(teacher)]
    <- if (max_meals(Max) & N <= Max) {
           !offer(V,food(N));
       } else {
           .send(teacher,tell,refused(V,insufficient_food_capacity));
       }.
