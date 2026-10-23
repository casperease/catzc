---
catzc:
  config:
    pattern: fact
    deck: for-compliance-auditor
    order: 19
    picture:
      mode: reduce
      source: ../../design/.assets/every-deploy-stage-is-main-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-LOOSETEAMS
---

# Loosely coupled teams: every deployable unit versions and releases on its own

## Eyebrow

19 / 30 · fact for the Compliance Auditor · RDR-DORA-LOOSETEAMS

## Lead

For the Compliance Auditor, who reads the history and the registry: cats is a mono repo, not a monolith; there is no repo-wide freeze or release train.

## Image

.assets/rdr-dora-looseteams-19.png

## Caption

From the catalogue, reduced: every deploy stage is main only.

## Notes

Check it: the record RDR-DORA-LOOSETEAMS in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-deploy-stage-is-main-only.drawio.png.
