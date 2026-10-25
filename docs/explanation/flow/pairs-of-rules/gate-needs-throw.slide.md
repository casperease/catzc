---
catzc:
  config:
    pattern: fact
    deck: pairs-of-rules
    order: 5
    picture:
      mode: reduce
      source: ../../design/.assets/one-door-in-one-stable-point-out.drawio.png
      scale: 0.4
      rotate: -4
---

# A gate stops a run only because an error is thrown: ADR-AUTO-TEST rests on ADR-PWSH-ERROR

## Eyebrow

5 / 14 · fact · ADR-AUTO-TEST

## Lead

Write-Error leaves the pipeline green. The test level that must turn it red throws.

## Image

.assets/gate-needs-throw.png

## Caption

From the catalogue, reduced: one door in one stable point out.

## Notes

Check it: the record ADR-AUTO-TEST in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/one-door-in-one-stable-point-out.drawio.png.
