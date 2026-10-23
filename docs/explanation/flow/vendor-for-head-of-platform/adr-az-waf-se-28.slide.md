---
catzc:
  config:
    pattern: fact
    deck: vendor-for-head-of-platform
    order: 28
    picture:
      mode: reduce
      source: ../../configuration/.assets/three-caches-back-one-reader.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-SE
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the Head of Platform · ADR-AZ-WAF-SE

## Lead

For the Head of Platform, who runs the platform other teams build on: The clone has no authority; the pull request authenticates; the bypass is recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: three caches back one reader.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/three-caches-back-one-reader.drawio.png.
