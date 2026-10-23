---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 1
    picture:
      mode: reduce
      source: ../../design/.assets/merging-to-main-is-what-deploys.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the Head of Platform · ADR-ADO-AUTH

## Lead

For the Head of Platform, who runs the platform other teams build on: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: merging to main is what deploys.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/explanation/design/.assets/merging-to-main-is-what-deploys.drawio.png.
