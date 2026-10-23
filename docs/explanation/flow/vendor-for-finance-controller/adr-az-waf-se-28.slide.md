---
catzc:
  config:
    pattern: fact
    deck: vendor-for-finance-controller
    order: 28
    picture:
      mode: reduce
      source: ../../design/.assets/each-track-picks-its-catch-all.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-SE
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the Finance Controller · ADR-AZ-WAF-SE

## Lead

For the Finance Controller, who pays for every environment and every wait: The clone has no authority; the pull request authenticates; the bypass is recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: each track picks its catch all.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/each-track-picks-its-catch-all.drawio.png.
