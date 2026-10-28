---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 9
    picture:
      mode: reduce
      source: ../../configuration/.assets/one-gate-guards-the-read-path.drawio.png
      scale: 0.4
---

# The one full Test-Automation run is the last act of a session, in a fresh process

## Eyebrow

9 / 14 · fact · ADR-AUTO-TEST

## Lead

C# type edits recompile only in a new pwsh. A gate claimed passed is a gate that was run and read; the output, failures included, is the
report.

## Image

[one-full-test-run](.assets/one-full-test-run.png)

## Caption

From the catalogue, reduced: one gate guards the read path.

## Notes

Check it: the record ADR-AUTO-TEST in docs/drs/index.md, and the diagram
docs/explanation/configuration/.assets/one-gate-guards-the-read-path.drawio.png.
