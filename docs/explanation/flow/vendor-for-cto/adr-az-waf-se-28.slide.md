---
catzc:
  config:
    pattern: fact
    deck: vendor-for-cto
    order: 28
    picture:
      mode: reduce
      source: ../../design/.assets/sync-point-rules-are-drs-only.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-SE
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the CTO · ADR-AZ-WAF-SE

## Lead

For the CTO, who owns the delivery system and its cost: The clone has no authority; the pull request authenticates; the bypass is recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: sync point rules are drs only.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/sync-point-rules-are-drs-only.drawio.png.
