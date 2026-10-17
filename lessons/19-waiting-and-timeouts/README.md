# Lesson 19: Waiting for conditions and handling timeouts

## The situation

The robot waits until a sensor is ready, while another intention supplies the simulated reading. It also demonstrates a bounded wait for an event that never arrives.

## Run it

From the repository root (Java 21 and Jason 3.3.0; see [setup](../../docs/SETUP.md)):

```bash
cd lessons/19-waiting-and-timeouts
jason main.mas2j
```

## Read the program

### `robot.asl`

```asl
!start.
+!start <- !!sensor;
           .wait(ready,1000);
           .print("Ready condition observed");
           !missing_event.
+!sensor <- .wait(50); +ready.
+!missing_event <- .wait({+never_arrives},50).
-!missing_event <- .print("Missing event timed out and was handled").
```

## How it works

- `.wait(ready,1000)` waits for a logical condition. If it already holds, there is no need for a new addition event.
- `.wait({+never_arrives},50)` waits for a future event, with braces around the trigger. An event wait does not mean “check whether this belief was added earlier.”
- The two-argument bounded wait fails on timeout; the failure plan handles that outcome. The three-argument event-wait form returns elapsed time and does not fail merely on timeout; do not treat its return alone as proof that the event happened.
- **B:** ready after the simulated sensor update. **D:** start, sensor, missing_event. **I:** a waiting foreground intention and the sensor intention. **Reactive:** waking on changes/events. Timeouts are in milliseconds and exact timing is not guaranteed.

## Expected observations

Agent prefixes and number formatting may differ. Look for these messages or fragments:

```text
Ready condition observed
Missing event timed out and was handled
```

Unless a lesson explicitly guarantees an order, treat these as observations, not a complete ordered transcript. Jason remains alive after the work finishes; stop it before rerunning.

## Try it yourself

1. Begin with `ready.` and remove the sensor launch.
2. Change the condition wait to an event wait and consider what happens if readiness was established before registration.

<details>
<summary>Hints and answers — predict first</summary>

The condition wait succeeds immediately with an initial ready belief. A future-event wait can miss an earlier event, so use a condition when persistent state is the real requirement.

</details>

## Explain it aloud

The robot waits until a sensor is ready, while another intention supplies the simulated reading. It also demonstrates a bounded wait for an event that never arrives. - `.wait(ready,1000)` waits for a logical condition. If it already holds, there is no need for a new addition event.
- `.wait({+never_arrives},50)` waits for a future event, with braces around the trigger. An event wait does not mean “check whether this belief was added earlier.”
- The two-argument bounded wait fails on timeout; the failure plan handles that outcome. The three-argument event-wait form returns elapsed time and does not fail merely on timeout; do not treat its return alone as proof that the event happened.
- **B:** ready after the simulated sensor update. **D:** start, sensor, missing_event. **I:** a waiting foreground intention and the sensor intention. **Reactive:** waking on changes/events. Timeouts are in milliseconds and exact timing is not guaranteed.
