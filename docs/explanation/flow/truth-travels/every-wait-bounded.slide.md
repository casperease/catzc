---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 6
    picture:
      mode: reduce
      source: ../../automation/.assets/what-a-run-stopped-by-its-limit-reports.drawio.png
      scale: 0.4
      rotate: -4
---

# Every call is bounded; a wait without a limit is a defect

## Eyebrow

6 / 15 · fact · ADR-AUTO-FAILFAST

## Lead

A gate that can hang is no gate. Every foreground call passes a time limit, every long run gets its own, and a denial is raised, never
retried larger.

## Image

[every-wait-bounded](.assets/every-wait-bounded.png)

## Caption

From the catalogue, reduced: a stopped run names its limit.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/what-a-run-stopped-by-its-limit-reports.drawio.png.
