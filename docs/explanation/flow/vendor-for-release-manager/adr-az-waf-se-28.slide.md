---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 28
    picture:
      mode: reduce
      source: ../../design/.assets/deploying-is-not-integrating.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-SE
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the Release Manager · ADR-AZ-WAF-SE

## Lead

For the Release Manager, who serves the signatures and watches the ladder: The clone has no authority; the pull request authenticates; the bypass is recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: deploying is not integrating.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/deploying-is-not-integrating.drawio.png.
