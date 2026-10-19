initial_plan(transport(10)).
max_seats(30).
{ include("participant.asl") }

+!revise(V,N,Weather)[source(teacher)]
    <- if (max_seats(Max) & N <= Max) {
           !offer(V,transport(N));
       } else {
           .send(teacher,tell,refused(V,insufficient_transport_capacity));
       }.
