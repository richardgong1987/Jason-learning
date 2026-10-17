!start.
+!start <- .send(worker,achieve,request(r1,book)); .send(worker,achieve,request(r1,book)).
+done(Id)[source(worker)] <- .print("Client observed completion: ",Id).
