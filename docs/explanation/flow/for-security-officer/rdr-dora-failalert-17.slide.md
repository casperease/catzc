---
catzc:
  config:
    pattern: fact
    deck: for-security-officer
    order: 17
    picture:
      mode: reduce
      source: ../../design/.assets/deploying-is-not-integrating.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-FAILALERT
---

# Proactive failure notification: a denied call is logged and raised, never swallowed

## Eyebrow

17 / 30 · fact for the Security Officer · RDR-DORA-FAILALERT

## Lead

For the Security Officer, who owns identity, policy and the audit trail: The time safeguard logs every denial; a gate turns the pipeline red by throwing.

## Image

.assets/rdr-dora-failalert-17.png

## Caption

From the catalogue, reduced: deploying is not integrating.

## Notes

Check it: the record RDR-DORA-FAILALERT in docs/drs/index.md, and the diagram docs/explanation/design/.assets/deploying-is-not-integrating.drawio.png.
