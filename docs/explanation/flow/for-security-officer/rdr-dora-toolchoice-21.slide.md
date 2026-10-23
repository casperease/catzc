---
catzc:
  config:
    pattern: fact
    deck: for-security-officer
    order: 21
    picture:
      mode: reduce
      source: ../../design/.assets/every-deploy-stage-is-main-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-TOOLCHOICE
---

# Teams choose tools within one living version: no second way to do a thing

## Eyebrow

21 / 30 · fact for the Security Officer · RDR-DORA-TOOLCHOICE

## Lead

For the Security Officer, who owns identity, policy and the audit trail: A tool is added through the package manager rule and vendored; a second mechanism is a defect.

## Image

.assets/rdr-dora-toolchoice-21.png

## Caption

From the catalogue, reduced: every deploy stage is main only.

## Notes

Check it: the record RDR-DORA-TOOLCHOICE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/every-deploy-stage-is-main-only.drawio.png.
