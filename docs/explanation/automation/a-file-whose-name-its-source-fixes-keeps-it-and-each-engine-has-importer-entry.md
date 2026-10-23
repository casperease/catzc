---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IDIOM-SOURCENAMEDEXEMPT
      - ADR-AUTO-ENGINE-IMPORTERENTRY
---

# A file whose name its source fixes keeps it and each engine has importer entry

This article is one rule: [ADR-AUTO-IDIOM-SOURCENAMEDEXEMPT](../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-sourcenamedexempt)
and [ADR-AUTO-ENGINE-IMPORTERENTRY](../../drs/automation/execution-engines.md#rule-adr-auto-engine-importerentry) merged into one. It holds
nothing beyond what those two rules say.

A file whose name its source fixes keeps that name: the files under an asset folder or a vendored folder, at any depth, and the files a
language's `naming:` entry lists by repository path as exempt, such as an entry script whose name every session types. Each engine reaches
catzc through its importer entry at the repository root, the POSIX engines sharing the one generated `importer.sh`.
