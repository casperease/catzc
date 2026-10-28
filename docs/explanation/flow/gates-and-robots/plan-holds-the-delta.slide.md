---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 8
---

# A plan holds the delta only, and a done plan is deleted

## Eyebrow

8 / 14 · fact · ADR-REPO-PLANS

## Lead

Plans live in .claude/plans as `plan-<topic>.md`; the master list carries the order; a landed step is struck, and once tested and committed
the plan is gone.

## Notes

Check it: the record ADR-REPO-PLANS in docs/drs/index.md.
