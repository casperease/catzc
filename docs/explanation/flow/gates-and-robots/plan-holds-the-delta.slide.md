---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 8
    picture:
      mode: reduce
      source: ../../automation/.assets/decide-returns-null-or-a-reason.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-REPO-PLANS
---

# A plan holds the delta only, and a done plan is deleted

## Eyebrow

8 / 14 · fact · ADR-REPO-PLANS

## Lead

Plans live in .claude/plans as plan-<topic>.md; the master list carries the order; a landed step is struck, and once tested and committed the plan is gone.

## Image

.assets/plan-holds-the-delta.png

## Caption

From the catalogue, reduced: decide returns null or a reason.

## Notes

Check it: the record ADR-REPO-PLANS in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/decide-returns-null-or-a-reason.drawio.png.
