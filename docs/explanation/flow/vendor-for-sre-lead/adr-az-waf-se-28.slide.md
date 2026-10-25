---
catzc:
  config:
    pattern: fact
    deck: vendor-for-sre-lead
    order: 28
    picture:
      mode: reduce
      source: ../../flow/.assets/pipeline-kinds-keyed-by-one-artifact.drawio.png
      scale: 0.4
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the SRE Lead · ADR-AZ-WAF-SE

## Lead

For the SRE Lead, who owns reliability, monitoring and the switch: The clone has no authority; the pull request authenticates; the bypass is
recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: pipeline kinds keyed by one artifact.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram
docs/explanation/flow/.assets/pipeline-kinds-keyed-by-one-artifact.drawio.png.
