---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 4
    picture:
      mode: reduce
      source: ../../azure/.assets/a-bad-coordinate-stops-discovery.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-ADO-VAR
---

# Azure DevOps: variables are declared once and injected at deploy time

## Eyebrow

4 / 30 · fact for the Security Officer · ADR-ADO-VAR

## Lead

For the Security Officer, who owns identity, policy and the audit trail: Secrets and some state are injected only at deploy; the repository holds a template through BVT.

## Image

.assets/adr-ado-var-4.png

## Caption

From the catalogue, reduced: a bad coordinate stops discovery.

## Notes

Check it: the record ADR-ADO-VAR in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/a-bad-coordinate-stops-discovery.drawio.png.
