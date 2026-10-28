---
catzc:
  config:
    pattern: fact
    deck: manual-queues
    order: 2
    picture:
      mode: reduce
      source: ../.assets/manual-queues-1-where-a-person-stands.drawio.png
      scale: 0.4
---

# The first queue is a person pushing their own topic; a clone never writes main

## Eyebrow

2 / 10 · fact · FDR-QUEUE-AUTHORINGISTHEFIRST

## Lead

A person edits one catalogue item and pushes it, as the authenticated author, to the server's topic HEAD. That push is the only remote write
the clone ever makes.

## Image

[authoring-is-first](.assets/authoring-is-first.png)

## Caption

Reduced: the ladder, whose first rung is queue 1, authoring, a person editing, pushing and merging; the landed main HEAD follows it.

## Notes

Check it: docs/drs/flow/manual-queues.md, rule AUTHORINGISTHEFIRST, and FDR-GIT-USERRUNSGIT.
