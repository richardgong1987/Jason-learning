!start.
+!start <- Original = parcel(alice,2);
           .term2string(Original,Text);
           .print("Serialized: ",Text);
           .term2string(Parsed,Text);
           Parsed = parcel(Customer,Count);
           .print("Parsed customer: ",Customer);
           .concat("Hello ","Alice",Greeting);
           .upper_case(Greeting,Upper);
           .length(Greeting,Length);
           .print("Greeting: ",Upper);
           .print("String length: ",Length);
           if (.number(Count) & .ground(Parsed)) { .print("Ground numeric payload"); }.
