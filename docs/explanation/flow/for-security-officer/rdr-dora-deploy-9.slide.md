---
catzc:
  config:
    pattern: fact
    deck: for-security-officer
    order: 9
    picture:
      mode: reduce
      source: ../../design/.assets/10-commits-story.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-DEPLOY
---

# Deployment automation: one artifact built once climbs every rung by pipeline

## Eyebrow

9 / 30 · fact for the Security Officer · RDR-DORA-DEPLOY

## Lead

For the Security Officer, who owns identity, policy and the audit trail: CD rolls the same tagged artifact onto each environment; the slot switch is automated and monitored.

## Image

.assets/rdr-dora-deploy-9.png

## Caption

From the catalogue, reduced: 10 commits story.

## Notes

Check it: the record RDR-DORA-DEPLOY in docs/drs/index.md, and the diagram docs/explanation/design/.assets/10-commits-story.drawio.png.
