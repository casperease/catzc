---
catzc:
  config:
    pattern: fact
    deck: a-day-in-cats
    order: 2
    picture:
      mode: reduce
      source: ../../../references/pwsh/.assets/how-the-azure-cli-session-is-checked.drawio.png
      scale: 0.4
      rotate: -4
---

# A probe uses the cheapest runner: a file read before a shell, a shell before the importer

## Eyebrow

2 / 12 · fact · ADR-AUTO-FAILFAST

## Lead

The importer is dot-sourced and heavy; a question about state is answered by cat, ls, grep or git, read-only.

## Image

[probe-cheaply](.assets/probe-cheaply.png)

## Caption

From the catalogue, reduced: two az checks, Test and Assert share one state call.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/references/pwsh/.assets/how-the-azure-cli-session-is-checked.drawio.png.
