---
catzc:
  config:
    pattern: fact
    deck: gates-and-robots
    order: 12
    picture:
      mode: reduce
      source: ../../automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png
      scale: 0.4
---

# A hook is compiled, denies a call that breaks the rule, and logs the denial

## Eyebrow

12 / 14 · fact · ADR-AUTO-FAILFAST

## Lead

The bash time safeguard is a hook under .claude/hooks; a hook-compiled file needs its build step in the burst that changes it.

## Image

[hook-compiled-verdict](.assets/hook-compiled-verdict.png)

## Caption

From the catalogue, reduced: a shell call carries its limit or is denied.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/explanation/automation/.assets/a-shell-call-carries-its-limit-or-is-denied.drawio.png.
