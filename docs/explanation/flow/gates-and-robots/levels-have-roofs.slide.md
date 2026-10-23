---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 2
    picture:
      mode: reduce
      source: ../../automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png
      scale: 0.4
      tilt: { y: 0.8, shear: 0.15 }
  edges:
    cites:
      - ADR-AUTO-TEST
---

# Every test level has a time roof, declared once in timeouts.yml

## Eyebrow

2 / 14 · fact · ADR-AUTO-TEST

## Lead

L0 is logic with no tree, L1 touches the real tree, L2 is the build verification test. A run over its roof is a finding, and the roof is raised by a person in the one config, never by the test.

## Image

.assets/levels-have-roofs.png

## Caption

From the catalogue, reduced: a shell call carries its limit or is denied.

## Notes

Check it: the record ADR-AUTO-TEST in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png.
