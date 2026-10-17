!start.
+!start <- .send(catalogue,askOne,price(book,P),Answer,1000);
           .print("One answer: ",Answer);
           .send(catalogue,askAll,price(Item,Cost),Answers,1000);
           .sort(Answers,Sorted); .print("All answers: ",Sorted).
