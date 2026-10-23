---
catzc:
  config:
    pattern: fact
    deck: for-finance-controller
    order: 19
    picture:
      mode: reduce
      source: ../../design/.assets/local-guard-and-server-policies.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - RDR-DORA-LOOSETEAMS
---

# Loosely coupled teams: every deployable unit versions and releases on its own

## Eyebrow

19 / 30 · fact for the Finance Controller · RDR-DORA-LOOSETEAMS

## Lead

For the Finance Controller, who pays for every environment and every wait: cats is a mono repo, not a monolith; there is no repo-wide freeze or release train.

## Image

.assets/rdr-dora-looseteams-19.png

## Caption

From the catalogue, reduced: local guard and server policies.

## Notes

Check it: the record RDR-DORA-LOOSETEAMS in docs/drs/index.md, and the diagram docs/explanation/design/.assets/local-guard-and-server-policies.drawio.png.
