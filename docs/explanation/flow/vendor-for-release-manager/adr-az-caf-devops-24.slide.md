---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 24
    picture:
      mode: reduce
      source: ../../design/.assets/clients-bridge-to-one-server.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-DEVOPS
---

# Azure CAF DevOps: the ladder, the queues and the gates are the DevOps answer

## Eyebrow

24 / 30 · fact for the Release Manager · ADR-AZ-CAF-DEVOPS

## Lead

For the Release Manager, who serves the signatures and watches the ladder: Trunk, BVT, two signatures, blue-green: the framework's items map to the flow records.

## Image

.assets/adr-az-caf-devops-24.png

## Caption

From the catalogue, reduced: clients bridge to one server.

## Notes

Check it: the record ADR-AZ-CAF-DEVOPS in docs/drs/index.md, and the diagram docs/explanation/design/.assets/clients-bridge-to-one-server.drawio.png.
