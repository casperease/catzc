---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 3
    picture:
      mode: reduce
      source: ../../azure/.assets/one-reverse-lookup-feeds-every-module.drawio.png
      scale: 0.4
---

# Every call is bounded; a foreground call carries its limit and a long run carries its own

## Eyebrow

3 / 14 · fact · ADR-AUTO-FAILFAST

## Lead

The hook denies a shell call without a limit and logs it. Exit 124 means the safeguard stopped the call. A denial is raised to a person,
never retried larger.

## Image

.assets/bound-every-wait.png

## Caption

From the catalogue, reduced: one reverse lookup feeds every module.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/explanation/azure/.assets/one-reverse-lookup-feeds-every-module.drawio.png.
