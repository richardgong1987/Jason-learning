!start.
+!start : door(closed)
    <- open(door);
       .wait(door(open),1000);
       .print("Environment confirmed open door").
+door(open)[source(percept)] <- .print("Reactive percept: door is open").
