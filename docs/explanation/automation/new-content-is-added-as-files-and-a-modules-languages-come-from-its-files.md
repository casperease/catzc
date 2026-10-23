---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-EXTEND-ADDNOTEDIT
      - ADR-AUTO-MODULE-LANGUAGESFROMFILES
---

# New content is added as files and a modules languages come from its files (ADR-AUTO-EXTEND-ADDNOTEDIT + ADR-AUTO-MODULE-LANGUAGESFROMFILES)

This article is one rule: [ADR-AUTO-EXTEND-ADDNOTEDIT](../../drs/automation/open-closed-architecture.md#rule-adr-auto-extend-addnotedit) and
[ADR-AUTO-MODULE-LANGUAGESFROMFILES](../../drs/automation/module-model.md#rule-adr-auto-module-languagesfromfiles) merged into one. It holds
nothing beyond what those two rules say.

Extend by adding, not editing: new functions, modules and dependencies are new files and folders, and the infrastructure, the importer
entries and the bootstrap loader, is never modified to accommodate them. A module's languages are likewise read, not declared: they are the
file languages of its live files, and each must be one the track declares, or the file is a stack violation.
