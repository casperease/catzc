---
catzc:
  config:
    pattern: fact
    deck: a-day-in-cats
    order: 11
    picture:
      mode: reduce
      source: ../../design/.assets/a-push-fires-only-touched-pipelines.drawio.png
      scale: 0.4
---

# The full test run is the last act, in a fresh pwsh, after everything else

## Eyebrow

11 / 12 · fact · ADR-AUTO-TEST

## Lead

C# type edits need a new process to recompile; the one full Test-Automation closes the session, and its output is the report.

## Image

.assets/full-run-last.png

## Caption

From the catalogue, reduced: a push fires only touched pipelines.

## Notes

Check it: the record ADR-AUTO-TEST in docs/drs/index.md, and the diagram
docs/explanation/design/.assets/a-push-fires-only-touched-pipelines.drawio.png.
