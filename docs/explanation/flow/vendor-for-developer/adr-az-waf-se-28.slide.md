---
catzc:
  config:
    pattern: fact
    deck: vendor-for-developer
    order: 28
    picture:
      mode: reduce
      source: ../../configuration/.assets/ask-by-name-get-the-cached-object.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-WAF-SE
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the Developer · ADR-AZ-WAF-SE

## Lead

For the Developer, who edits one file, runs one gate, pushes one topic: The clone has no authority; the pull request authenticates; the bypass is recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: ask by name get the cached object.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/ask-by-name-get-the-cached-object.drawio.png.
