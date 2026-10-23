---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 19
    picture:
      mode: reduce
      source: ../../design/.assets/out-from-the-verified-point-back-through-a-topic.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-SEC
---

# Azure CAF security: secrets are injected at deploy time and never stored in the tree

## Eyebrow

19 / 30 · fact for the Compliance Auditor · ADR-AZ-CAF-SEC

## Lead

For the Compliance Auditor, who reads the history and the registry: The repository holds a template through BVT; the value arrives only at deploy.

## Image

.assets/adr-az-caf-sec-19.png

## Caption

From the catalogue, reduced: out from the verified point back through a topic.

## Notes

Check it: the record ADR-AZ-CAF-SEC in docs/drs/index.md, and the diagram docs/explanation/design/.assets/out-from-the-verified-point-back-through-a-topic.drawio.png.
