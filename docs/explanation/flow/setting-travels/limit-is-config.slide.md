---
catzc:
  config:
    pattern: fact
    deck: setting-travels
    order: 6
    picture:
      mode: reduce
      source: ../../automation/.assets/how-the-hook-treats-a-shell-calls-limit.drawio.png
      scale: 0.4
      rotate: -4
---

# A time limit comes from timeouts.yml or a command's TimeLimit, never from a workaround

## Eyebrow

6 / 12 · fact · ADR-AUTO-FAILFAST

## Lead

A call that needs longer gets its roof raised in the one config, by a person; a retry with a bigger number is a denial, not a fix.

## Image

[limit-is-config](.assets/limit-is-config.png)

## Caption

From the catalogue, reduced: a shell call carries its limit or is denied.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/how-the-hook-treats-a-shell-calls-limit.drawio.png.
