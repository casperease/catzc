---
catzc:
  config:
    pattern: fact
    deck: for-security-officer
    order: 13
    picture:
      mode: reduce
      source: ../../design/.assets/clients-bridge-to-one-server.drawio.png
      scale: 0.4
  edges:
    cites:
      - RDR-DORA-DBCHANGE
---

# Database and config change travel in the same commit as the code

## Eyebrow

13 / 30 · fact for the Security Officer · RDR-DORA-DBCHANGE

## Lead

For the Security Officer, who owns identity, policy and the audit trail: A config entry is a catalogue item; it climbs the same ladder, in the same artifact.

## Image

.assets/rdr-dora-dbchange-13.png

## Caption

From the catalogue, reduced: clients bridge to one server.

## Notes

Check it: the record RDR-DORA-DBCHANGE in docs/drs/index.md, and the diagram docs/explanation/design/.assets/clients-bridge-to-one-server.drawio.png.
