---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-EXTEND-ADDNOTEDIT
      - ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE
---

# Extend by adding and every language track holds its modules alike

This article is one rule: [ADR-AUTO-EXTEND-ADDNOTEDIT](../../drs/automation/open-closed-architecture.md#rule-adr-auto-extend-addnotedit) and
[ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](../../drs/automation/module-model.md#rule-adr-auto-module-everylanguagetrackalike) merged into
one. It holds nothing beyond what those two rules say.

Extend by adding, not editing: new functions, modules and dependencies are new files and folders, and the importer entries and the bootstrap
loader are never modified to accommodate new content. The same shape holds one level up, a new root concern being a new track, and every
language track holds its modules the same way, a module being a non-dot folder directly under the track's root.
