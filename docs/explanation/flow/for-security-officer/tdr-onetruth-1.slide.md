---
catzc:
  config:
    pattern: fact
    deck: for-security-officer
    order: 1
    picture:
      mode: reduce
      source: ../../configuration/.assets/callers-depend-on-one-config-module.drawio.png
      scale: 0.4
  edges:
    cites:
      - TDR-ONETRUTH
---

# The repository is the one source of truth, and delivery is one change process

## Eyebrow

1 / 30 · fact for the Security Officer · TDR-ONETRUTH

## Lead

For the Security Officer, who owns identity, policy and the audit trail: Everything delivery touches is code in the repository; a reviewed commit is both the change and its delivery.

## Image

.assets/tdr-onetruth-1.png

## Caption

From the catalogue, reduced: callers depend on one config module.

## Notes

Check it: the record TDR-ONETRUTH in docs/drs/index.md, and the diagram docs/explanation/configuration/.assets/callers-depend-on-one-config-module.drawio.png.
