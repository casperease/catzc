---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 3
    picture:
      mode: reduce
      source: ../../design/.assets/clients-bridge-to-one-server.drawio.png
      scale: 0.4
  edges:
    cites:
      - FDR-CD-QUEUE-AUTHORINGISTHEFIRST
      - DDR-REMOTE-PULLREQUESTISINGRESS
---

# Main has two doors and no windows

## Eyebrow

3 / 10 · fact · FDR-CD-QUEUE-AUTHORINGISTHEFIRST

## Lead

Door one: the platform's atomic pull-request merge. Door two: a direct merge by a user the policy authorizes to bypass it, recorded. Both
take the server's own topic HEAD. The clone climbing in through a window is not a door.

## Image

.assets/two-doors.png

## Caption

Reduced: the way in, from a local clone through the identity model and the branch policy to HEAD.

## Notes

Check it: docs/drs/flow/manual-queues.md, rule AUTHORINGISTHEFIRST; docs/drs/design/server-remote-integration.md, PULLREQUESTISINGRESS.
