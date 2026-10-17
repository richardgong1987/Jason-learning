# Lesson 22: Belief annotations and source provenance

## The situation

The robot has readings from different sensors. An annotation records metadata, and a query can require a particular source.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/22-annotations-and-provenance
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
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
```

## How it works

- Annotations follow a literal in square brackets. Here `source(...)` records origin and `unit(...)` records a measurement unit.
- An annotated query can match a belief with additional annotations; a query without annotations can match either reading.
- These local source labels are demonstrations. A source annotation is metadata, not cryptographic proof or a trust policy.
- **B:** annotated readings. **D:** start. **I:** the query/print plan. Lesson 23 uses the actual sender annotations that Jason adds to messages.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Sensor A: 20
Sensor B: 22
All readings: [20,22]
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Require the wrong unit in the query.
2. Use `.findall(S,temperature(_)[source(S)],Sources)` to inspect the sources.

<details>
<summary>Hints and answers — predict first</summary>

A missing required annotation makes the query fail. Enumerating source annotations exposes origin metadata; it does not establish accuracy of the reported reading.

</details>

## Explain it aloud

The robot has readings from different sensors. An annotation records metadata, and a query can require a particular source. - Annotations follow a literal in square brackets. Here `source(...)` records origin and `unit(...)` records a measurement unit.
- An annotated query can match a belief with additional annotations; a query without annotations can match either reading.
- These local source labels are demonstrations. A source annotation is metadata, not cryptographic proof or a trust policy.
- **B:** annotated readings. **D:** start. **I:** the query/print plan. Lesson 23 uses the actual sender annotations that Jason adds to messages.
