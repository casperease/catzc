---
catzc:
  config:
    pattern: fact
    deck: for-release-manager
    order: 14
    picture:
      mode: reduce
      source: ../../flow/.assets/three-tasks-one-guard-one-runner.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-SECURITY
---

# Pervasive security: identity and branch policy are the server's, and the clone has none

## Eyebrow

14 / 30 · fact for the Release Manager · RDR-DORA-SECURITY

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The pull request authenticates the author and merges the server's own topic HEAD; a bypass is authorized and recorded.

## Image

.assets/rdr-dora-security-14.png

## Caption

From the catalogue, reduced: three tasks one guard one runner.

## Notes

Check it: the record RDR-DORA-SECURITY in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/three-tasks-one-guard-one-runner.drawio.png.
