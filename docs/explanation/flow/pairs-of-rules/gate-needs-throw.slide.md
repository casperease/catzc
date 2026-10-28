---
catzc:
  config:
    pattern: fact
    deck: pairs-of-rules
    order: 5
    picture:
      mode: reduce
      source: ../.assets/drift-is-gated-generation-is-drs-only.drawio.png
      scale: 0.4
      rotate: -4
---

# A gate stops a run only because an error is thrown: ADR-AUTO-TEST rests on ADR-PWSH-ERROR

## Eyebrow

5 / 14 · fact · ADR-AUTO-TEST

## Lead

Write-Error leaves the pipeline green. The test level that must turn it red throws.

## Image

[gate-needs-throw](.assets/gate-needs-throw.png)

## Caption

From the catalogue, reduced: drift is gated, generation is DRS only.

## Notes

Check it: the record ADR-AUTO-TEST in docs/drs/index.md, and the diagram
docs/explanation/flow/.assets/drift-is-gated-generation-is-drs-only.drawio.png.
