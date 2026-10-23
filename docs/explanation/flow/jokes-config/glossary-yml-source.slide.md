---
catzc:
  config:
    pattern: fact
    deck: jokes-config
    order: 9
    picture:
      mode: reduce
      source: ../../flow/.assets/stop-only-on-false-everything-else-proceeds.drawio.png
      scale: 0.4
      rotate: -4
  edges:
    cites:
      - ADR-REPO-VOCAB
---

# The glossary page is generated; John the computer guy edited it and it politely regenerated over him

## Eyebrow

9 / 10 · fact · ADR-REPO-VOCAB

## Lead

Edit a module's glossary.yml source, never the page; Build-Glossary writes the page, Test-Glossary checks the terms.

## Image

.assets/glossary-yml-source.png

## Caption

From the catalogue, reduced: stop only on false everything else proceeds.

## Notes

Check it: the record ADR-REPO-VOCAB in docs/drs/index.md, and the diagram docs/explanation/flow/.assets/stop-only-on-false-everything-else-proceeds.drawio.png.
