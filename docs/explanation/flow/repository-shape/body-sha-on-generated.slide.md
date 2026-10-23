---
catzc:
  config:
    pattern: fact
    deck: repository-shape
    order: 6
    picture:
      mode: reduce
      source: ../../automation/.assets/pass-the-limit-or-the-call-is-denied.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-REPO-FILEMETA
---

# A generated tracked file carries its body's hash in its head, and nothing else stamps it

## Eyebrow

6 / 14 · fact · ADR-REPO-FILEMETA

## Lead

No inputs hash, no gitignored stamp companion: generators always render, and Write-FileIfChanged decides whether the file changes.

## Image

.assets/body-sha-on-generated.png

## Caption

From the catalogue, reduced: pass the limit or the call is denied.

## Notes

Check it: the record ADR-REPO-FILEMETA in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/pass-the-limit-or-the-call-is-denied.drawio.png.
