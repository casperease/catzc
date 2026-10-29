---
catzc:
  config:
    pattern: fact
    deck: truth-travels
    order: 8
    picture:
      mode: reduce
      source: ../../automation/.assets/what-checks-each-load-stage.drawio.png
      scale: 0.4
---

# An error is thrown, never written; a gate that cannot throw cannot stop a run

## Eyebrow

8 / 15 · fact · ADR-PWSH-ERROR

## Lead

Write-Error leaves a run going. A thrown error ends it at the line that found the fault, with the message that names it, so the pipeline
turns red.

## Image

[throw-not-write](.assets/throw-not-write.png)

## Caption

From the catalogue, reduced: rule and gate per load stage.

## Notes

Check it: the record ADR-PWSH-ERROR in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/what-checks-each-load-stage.drawio.png.
