---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 1
    picture:
      mode: reduce
      source: ../../design/.assets/one-unit-one-pipeline.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the Developer · ADR-ADO-AUTH

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: one unit one pipeline.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/explanation/design/.assets/one-unit-one-pipeline.drawio.png.
