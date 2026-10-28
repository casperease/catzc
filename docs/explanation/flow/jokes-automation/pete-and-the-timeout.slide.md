---
catzc:
  config:
    pattern: fact
    deck: jokes-automation
    order: 1
    picture:
      mode: reduce
      source: ../../automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png
      scale: 0.4
---

# Pete from IT ran a command without a limit; the hook denied it before Pete finished his coffee

## Eyebrow

1 / 10 · fact · ADR-AUTO-FAILFAST

## Lead

Every call is bounded. A foreground call carries its limit; a long run carries its own; exit 124 means the safeguard, not Pete, stopped it.

## Image

[pete-and-the-timeout](.assets/pete-and-the-timeout.png)

## Caption

From the catalogue, reduced: a shell call carries its limit, or the hook denies it.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png.
