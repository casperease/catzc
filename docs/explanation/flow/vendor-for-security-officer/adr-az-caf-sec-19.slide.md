---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 19
    picture:
      mode: reduce
      source: ../../design/.assets/one-way-climb-three-endings.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-SEC
---

# Azure CAF security: secrets are injected at deploy time and never stored in the tree

## Eyebrow

19 / 30 · fact for the Security Officer · ADR-AZ-CAF-SEC

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The repository holds a template through BVT; the value arrives only at deploy.

## Image

.assets/adr-az-caf-sec-19.png

## Caption

From the catalogue, reduced: one way climb three endings.

## Notes

Check it: the record ADR-AZ-CAF-SEC in docs/drs/index.md, and the diagram docs/explanation/design/.assets/one-way-climb-three-endings.drawio.png.
