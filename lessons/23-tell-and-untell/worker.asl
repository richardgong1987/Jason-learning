+!process(Id)[source(Sender)] : job(Id,Item)[source(Sender)]
    <- .print("Worker processed: ",Id); .send(Sender,tell,done(Id)).
-job(Id,Item)[source(manager)] <- .print("Worker saw job information withdrawn: ",Id).
