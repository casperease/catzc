---
catzc:
  config:
    pattern: fact
    deck: vendor-for-qa-lead
    order: 1
    picture:
      mode: reduce
      source: ../../../../docs/references/pwsh/.assets/invoke-tool-asserts-locked-version.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-ADO-AUTH
---

# Azure DevOps: a configured credential proves its organization before any call

## Eyebrow

1 / 30 · fact for the QA Lead · ADR-ADO-AUTH

## Lead

For the QA Lead, who owns the test levels and their roofs: The credential is checked against the org it claims; a mismatch stops discovery at the first call.

## Image

.assets/adr-ado-auth-1.png

## Caption

From the catalogue, reduced: invoke tool asserts locked version.

## Notes

Check it: the record ADR-ADO-AUTH in docs/drs/index.md, and the diagram docs/references/pwsh/.assets/invoke-tool-asserts-locked-version.drawio.png.
