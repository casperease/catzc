---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 19
    picture:
      mode: reduce
      source: ../../automation/.assets/pass-the-limit-or-the-call-is-denied.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-CAF-SEC
---

# Azure CAF security: secrets are injected at deploy time and never stored in the tree

## Eyebrow

19 / 30 · fact for the Finance Controller · ADR-AZ-CAF-SEC

## Lead

For the Finance Controller, who pays for every environment and every wait: The repository holds a template through BVT; the value arrives only at deploy.

## Image

.assets/adr-az-caf-sec-19.png

## Caption

From the catalogue, reduced: pass the limit or the call is denied.

## Notes

Check it: the record ADR-AZ-CAF-SEC in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/pass-the-limit-or-the-call-is-denied.drawio.png.
