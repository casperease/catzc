---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 28
    picture:
      mode: reduce
      source: ../../thesis/.assets/eac-normal-form.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-SE
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the Product Owner · ADR-AZ-WAF-SE

## Lead

For the Product Owner, who wants small batches and visible work: The clone has no authority; the pull request authenticates; the bypass is recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: eac normal form.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram docs/explanation/thesis/.assets/eac-normal-form.drawio.png.
