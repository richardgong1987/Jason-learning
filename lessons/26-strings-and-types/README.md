# Lesson 26: Strings, term conversion, and type checks

## The situation

A robot converts a structured message to text and back. A printed string and an executable term are different values.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/26-strings-and-types
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
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
```

## How it works

- `.term2string(Term,String)` can serialize a term or parse a string, depending on which argument is bound.
- Parsing text does not validate its meaning. Unifying with `parcel(Customer,Count)` checks the expected shape; `.number` and `.ground` add simple type/instantiation checks.
- `.concat`, `.upper_case`, and `.length` operate on the greeting string here. String length includes the space.
- **B:** none. **D:** start. **I:** conversion plan. Parsing received text is not a reason to accept or execute arbitrary plans from an untrusted sender.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Serialized: parcel(alice,2)
Parsed customer: alice
Greeting: HELLO ALICE
String length: 11
Ground numeric payload
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Change the count to the atom two and inspect the numeric branch.
2. Parse `parcel(bob,3)` from a literal string.

<details>
<summary>Hints and answers — predict first</summary>

The type branch no longer runs for the atom two. To parse directly, call `.term2string(T,"parcel(bob,3)")`, then validate T before using its fields.

</details>

## Explain it aloud

A robot converts a structured message to text and back. A printed string and an executable term are different values. - `.term2string(Term,String)` can serialize a term or parse a string, depending on which argument is bound.
- Parsing text does not validate its meaning. Unifying with `parcel(Customer,Count)` checks the expected shape; `.number` and `.ground` add simple type/instantiation checks.
- `.concat`, `.upper_case`, and `.length` operate on the greeting string here. String length includes the space.
- **B:** none. **D:** start. **I:** conversion plan. Parsing received text is not a reason to accept or execute arbitrary plans from an untrusted sender.
