---
catzc:
  config:
    pattern: fact
    deck: repository-shape
    order: 6
    picture:
      mode: reduce
      source: ../../../how-to/pwsh/.assets/head-outcomes.drawio.png
      scale: 0.4
---

# A generated tracked file carries its body's hash in its head, and nothing else stamps it

## Eyebrow

6 / 14 · fact · ADR-REPO-FILEMETA

## Lead

No inputs hash, no gitignored stamp companion: generators always render, and Write-FileIfChanged decides whether the file changes.

## Image

[body-sha-on-generated](.assets/body-sha-on-generated.png)

## Caption

From the catalogue, reduced: head outcomes.

## Notes

Check it: the record ADR-REPO-FILEMETA in docs/drs/index.md, and the diagram docs/how-to/pwsh/.assets/head-outcomes.drawio.png.
