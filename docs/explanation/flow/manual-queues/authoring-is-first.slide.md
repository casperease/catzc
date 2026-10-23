---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 2
    picture:
      mode: zoom
      source: ../../design/.assets/out-from-the-verified-point-back-through-a-topic.drawio.png
      box: [20, 84, 1260, 400]
      scale: 0.5
  edges:
    cites:
      - FDR-CD-QUEUE-AUTHORINGISTHEFIRST
---

# The first queue is a person pushing their own topic; a clone never writes main

## Eyebrow

2 / 10 · fact · FDR-CD-QUEUE-AUTHORINGISTHEFIRST

## Lead

A person edits one catalogue item and pushes it, as the authenticated author, to the server's topic HEAD. That push is the only remote
write the clone ever makes.

## Image

.assets/authoring-is-first.png

## Caption

Zoomed: the clone leaves from the verified point, commits, and pushes up to its own topic HEAD on the server remote.

## Notes

Check it: docs/drs/flow/manual-queues.md, rule AUTHORINGISTHEFIRST, and FDR-GIT-USERRUNSGIT.
