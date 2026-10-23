---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 27
    picture:
      mode: reduce
      source: ../../azure/.assets/the-session-is-the-deploy-target.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-AZ-WAF-RE
---

# Azure WAF reliability: pre-prod and production trade places blue-green, reversible by the same path

## Eyebrow

27 / 30 · fact for the QA Lead · ADR-AZ-WAF-RE

## Lead

For the QA Lead, who owns the test levels and their roofs: The switch is automated, monitored and reversible; reliability is a rung, not a hope.

## Image

.assets/adr-az-waf-re-27.png

## Caption

From the catalogue, reduced: the session is the deploy target.

## Notes

Check it: the record ADR-AZ-WAF-RE in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/the-session-is-the-deploy-target.drawio.png.
