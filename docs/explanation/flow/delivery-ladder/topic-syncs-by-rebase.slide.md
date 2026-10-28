---
catzc:
  config:
    pattern: fact
    deck: delivery-ladder
    order: 1
---

# A topic takes upstream changes by rebasing onto the sync point, never by merging main into it

## Eyebrow

1 / 12 · fact · FDR-GIT

## Lead

A rebase keeps the topic a straight line of its own commits on one server commit; a merge of main in brings other people's changes along.

## Notes

Check it: the record FDR-GIT in docs/drs/index.md.
