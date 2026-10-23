---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 27
    picture:
      mode: reduce
      source: ../../design/.assets/sync-from-the-bvt-verified-head.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-WAF-RE
---

# Azure WAF reliability: pre-prod and production trade places blue-green, reversible by the same path

## Eyebrow

27 / 30 · fact for the Security Officer · ADR-AZ-WAF-RE

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The switch is automated, monitored and reversible; reliability is a rung, not a hope.

## Image

.assets/adr-az-waf-re-27.png

## Caption

From the catalogue, reduced: sync from the bvt verified head.

## Notes

Check it: the record ADR-AZ-WAF-RE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/sync-from-the-bvt-verified-head.drawio.png.
