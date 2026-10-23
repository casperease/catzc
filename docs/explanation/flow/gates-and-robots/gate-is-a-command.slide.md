---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 1
    picture:
      mode: reduce
      source: ../../azure/.assets/names-are-pure-and-never-truncated.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AUTO-TEST
---

# A quality gate is one command with one verdict, run the same way by a person, a robot and a pipeline

## Eyebrow

1 / 14 · fact · ADR-AUTO-TEST

## Lead

Test-Links, Test-Glossary, Test-Diagrams, Test-Slides and Test-Plans each read the tree and write a report under out/; a pipeline runs the same command and turns red on the same finding.

## Image

.assets/gate-is-a-command.png

## Caption

From the catalogue, reduced: names are pure and never truncated.

## Notes

Check it: the record ADR-AUTO-TEST in docs/drs/index.md, and the diagram docs/explanation/azure/.assets/names-are-pure-and-never-truncated.drawio.png.
