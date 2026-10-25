---
catzc:
  config:
    pattern: fact
    deck: jokes-automation
    order: 1
    picture:
      mode: reduce
      source: ../../configuration/.assets/one-reader-one-cache-per-session.drawio.png
      scale: 0.4
---

# Pete from IT ran a command without a limit; the hook denied it before Pete finished his coffee

## Eyebrow

1 / 10 · fact · ADR-AUTO-FAILFAST

## Lead

Every call is bounded. A foreground call carries its limit; a long run carries its own; exit 124 means the safeguard, not Pete, stopped it.

## Image

.assets/pete-and-the-timeout.png

## Caption

From the catalogue, reduced: one reader one cache per session.

## Notes

Check it: the record ADR-AUTO-FAILFAST in docs/drs/index.md, and the diagram
docs/explanation/configuration/.assets/one-reader-one-cache-per-session.drawio.png.
