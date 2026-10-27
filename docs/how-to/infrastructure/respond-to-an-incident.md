# Respond to an incident

An incident is anything that harms a production service or its data, or exposes it: an outage, a failed deploy that degraded a service, a
leaked secret, or an alert that a person must act on. The response has one owner from start to finish and keeps a written record, so the fix
and the lesson outlast the people who were there.

## Respond

1. **Declare it.** The person who notices it opens an incident record with the time, the symptom and the affected environment, and names an
   incident owner. The owner decides, the others help.
2. **Assess it.** Find what is affected and since when, from the alerts and the logs in `foundation`'s Log Analytics workspace. Name its
   severity: production down or data at risk is the highest.
3. **Contain it.**
   - A failed deploy: deploy the last good commit's artifact again through the unit's DEPLOY pipeline.
   - A leaked secret: seed a new value at once and deploy every template that reads it (see [seed a secret](seed-a-secret.md)).
   - A lost resource or lost data: follow [recover from a disaster](recover-from-a-disaster.md).
   - A change that cannot wait for the normal flow: follow [make an emergency change](make-an-emergency-change.md).
4. **Communicate.** The owner tells the service's users what is affected and when to expect the next update, and gives that update when
   promised.
5. **Resolve it.** The incident closes when the service works again and nothing is still exposed.

## Learn from it

Within a week of closing, the owner writes a blameless review in the incident record: the timeline, the cause, what worked, and the changes
that keep it from recurring. Each change becomes a planned piece of work, with its own check, so the review does not end as a note nobody
acts on.
