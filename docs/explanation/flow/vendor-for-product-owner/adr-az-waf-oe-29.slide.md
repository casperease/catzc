---
catzc:
  config:
    pattern: fact
    deck: vendor-for-product-owner
    order: 29
    picture:
      mode: reduce
      source: ../../flow/.assets/cd-builds-once-then-deploys-prod-itself.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-OE
---

# Azure WAF operational excellence: one command per step, one gate per rule, one report per run

## Eyebrow

29 / 30 · fact for the Product Owner · ADR-AZ-WAF-OE

## Lead

For the Product Owner, who wants small batches and visible work: Every pipeline step names a cats command; every gate writes its report; nothing is clicked.

## Image

.assets/adr-az-waf-oe-29.png

## Caption

From the catalogue, reduced: cd builds once then deploys prod itself.

## Notes

Check it: the record ADR-AZ-WAF-OE in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/cd-builds-once-then-deploys-prod-itself.drawio.png.
