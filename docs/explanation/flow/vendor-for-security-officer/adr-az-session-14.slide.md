---
catzc:
  config:
    pattern: fact
    deck: vendor-for-security-officer
    order: 14
    picture:
      mode: reduce
      source: ../../azure/.assets/lookup-form-check-render-in-order.drawio.png
      scale: 0.4
      tilt: { y: 0.75, shear: -0.15 }
  edges:
    cites:
      - ADR-AZ-SESSION
---

# Azure: a session is authenticated once and asserted before every command

## Eyebrow

14 / 30 · fact for the Security Officer · ADR-AZ-SESSION

## Lead

For the Security Officer, who owns identity, policy and the audit trail: A guard checks the session; a guard's verdict is never cached across a session.

## Image

.assets/adr-az-session-14.png

## Caption

From the catalogue, reduced: lookup form check render in order.

## Notes

Check it: the record ADR-AZ-SESSION in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/lookup-form-check-render-in-order.drawio.png.
