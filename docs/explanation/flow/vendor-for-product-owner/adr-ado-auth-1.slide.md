---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 1
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/listen-mode-flow.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the Product Owner · ADR-ADO-AUTH

## Lead

For the Product Owner, who wants small batches and visible work: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: listen mode flow.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/listen-mode-flow.drawio.png.
