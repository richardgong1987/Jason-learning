temperature(20)[source(sensor_a),unit(celsius)].
temperature(22)[source(sensor_b),unit(celsius)].
!start.
+!start <- ?temperature(A)[source(sensor_a)];
           ?temperature(B)[source(sensor_b),unit(celsius)];
           .print("Sensor A: ",A);
           .print("Sensor B: ",B);
           .findall(T,temperature(T),Values);
           .sort(Values,Sorted);
           .print("All readings: ",Sorted).
