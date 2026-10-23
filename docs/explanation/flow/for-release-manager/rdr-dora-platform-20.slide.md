---
catzc:
  config:
    pattern: fact
    deck: for-release-manager
    order: 20
    picture:
      mode: reduce
      source: ../../flow/.assets/cd-builds-once-then-deploys-prod-itself.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-PLATFORM
---

# Platform engineering: cats ships the tooling, and each team runs it against its own organization

## Eyebrow

20 / 30 · fact for the Release Manager · RDR-DORA-PLATFORM

## Lead

For the Release Manager, who serves the signatures and watches the ladder: Approvals, policies and pipelines are config plus one apply command; no approver is hardcoded.

## Image

.assets/rdr-dora-platform-20.png

## Caption

From the catalogue, reduced: cd builds once then deploys prod itself.

## Notes

Check it: the record RDR-DORA-PLATFORM in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/cd-builds-once-then-deploys-prod-itself.drawio.png.
