@execute[atomic]
+!request(Id,Item)[source(Sender)]
    <- if (not processed(Id)) {
           +processed(Id); .print("EXECUTED request: ",Id);
       } else { .print("DUPLICATE request: ",Id); };
       .send(Sender,tell,done(Id)).
