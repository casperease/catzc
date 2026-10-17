---
catzc:
  edges:
    cites:
      - ADR-THES-ONETRUTH#1
  config:
    pattern: statement
    deck: product-thesis
    order: 4
---

# Remove the problem instead of managing it

## Eyebrow

The decision

## Lead

Everything delivery touches is code in the repository. Changing anything and delivering it are the same motion: a reviewed commit,
integrated into the trunk and delivered by its pipelines.

## Body

That keeps the trunk always releasable, which is continuous delivery as the DORA research defines it. Audit and retrospection are answered
once, by the history.

## Notes

The one decision. A commit is both the change and the delivery, so there is nothing to keep in step with anything else.
