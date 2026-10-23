---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 19
    picture:
      mode: reduce
      source: ../../repository/.assets/opted-in-then-link-copy-or-render.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-SEC
---

# Azure CAF security: secrets are injected at deploy time and never stored in the tree

## Eyebrow

19 / 30 · fact for the Developer · ADR-AZ-CAF-SEC

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The repository holds a template through BVT; the value arrives only at deploy.

## Image

.assets/adr-az-caf-sec-19.png

## Caption

From the catalogue, reduced: opted in then link copy or render.

## Notes

Check it: the record ADR-AZ-CAF-SEC in docs/drs/index.md, and the diagram docs/explanation/repository/.assets/opted-in-then-link-copy-or-render.drawio.png.
