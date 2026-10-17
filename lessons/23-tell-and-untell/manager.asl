!start.
+!start <- .send(worker,tell,job(j1,book)); .send(worker,achieve,process(j1)).
+done(Id)[source(worker)] <- .print("Manager received completion: ",Id); .send(worker,untell,job(Id,book)).
