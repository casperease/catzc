---
catzc:
  config:
    pattern: fact
    deck: jokes-automation
    order: 8
    picture:
      mode: reduce
      source: ../../automation/.assets/every-entry-runs-one-load-sequence.drawio.png
      scale: 0.4
  edges:
    cites:
      - ADR-AUTO-FAILFAST
---

# The hook has no feelings, only a verdict and a log line, which makes it the calmest colleague

## Eyebrow

8 / 10 · fact · ADR-AUTO-FAILFAST

## Lead

A hook is compiled, denies a call that breaks the rule, and logs the denial; a hook-compiled file is rebuilt in the burst that changes it.

## Image

.assets/hook-compiled-feelings.png

## Caption

From the catalogue, reduced: every entry runs one load sequence.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram docs/explanation/automation/.assets/every-entry-runs-one-load-sequence.drawio.png.
