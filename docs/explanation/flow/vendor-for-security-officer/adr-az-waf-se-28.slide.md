---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 28
    picture:
      mode: reduce
      source: ../../automation/.assets/a-stopped-run-names-its-limit.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-SE
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the Security Officer · ADR-AZ-WAF-SE

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The clone has no authority; the pull request authenticates; the bypass is recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: a stopped run names its limit.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/a-stopped-run-names-its-limit.drawio.png.
