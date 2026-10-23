---
catzc:
  config:
    pattern: fact
    deck: vendor-for-compliance-auditor
    order: 28
    picture:
      mode: reduce
      source: ../../automation/.assets/build-verify-then-copy-the-folder.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AZ-WAF-SE
---

# Azure WAF security: identity on the server, secrets at deploy, policy from code

## Eyebrow

28 / 30 · fact for the Compliance Auditor · ADR-AZ-WAF-SE

## Lead

For the Compliance Auditor, who reads the history and the registry: The clone has no authority; the pull request authenticates; the bypass is recorded.

## Image

.assets/adr-az-waf-se-28.png

## Caption

From the catalogue, reduced: build verify then copy the folder.

## Notes

Check it: the record ADR-AZ-WAF-SE in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/build-verify-then-copy-the-folder.drawio.png.
