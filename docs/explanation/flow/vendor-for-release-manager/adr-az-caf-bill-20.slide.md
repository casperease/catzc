---
catzc:
  config:
    pattern: fact
    deck: vendor-for-release-manager
    order: 20
    picture:
      mode: reduce
      source: ../../design/.assets/10-commits-story.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AZ-CAF-BILL
---

# Azure CAF billing: every environment is a named slot with a known owner and a known cost

## Eyebrow

20 / 30 · fact for the Release Manager · ADR-AZ-CAF-BILL

## Lead

For the Release Manager, who serves the signatures and watches the ladder: One occupant per environment keeps the bill a list of named rungs.

## Image

.assets/adr-az-caf-bill-20.png

## Caption

From the catalogue, reduced: 10 commits story.

## Notes

Check it: the record ADR-AZ-CAF-BILL in docs/drs/index.md, and the diagram docs/explanation/design/.assets/10-commits-story.drawio.png.
