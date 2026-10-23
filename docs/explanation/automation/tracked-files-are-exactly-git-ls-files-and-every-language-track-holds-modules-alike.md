---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TRACKED-SAMEASLSFILES
      - ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE
---

# Tracked files are exactly git ls files and every language track holds modules alike (ADR-AUTO-TRACKED-SAMEASLSFILES + ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE)

This article is one rule:
[ADR-AUTO-TRACKED-SAMEASLSFILES](../../drs/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked-sameaslsfiles) and
[ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](../../drs/automation/module-model.md#rule-adr-auto-module-everylanguagetrackalike) merged into
one. It holds nothing beyond what those two rules say.

The tracked-file answer is exactly what plain `git ls-files` prints: every index entry, repo-relative and `/`-separated, in index order, so
a file deleted from the working tree but still in the index is listed. Modules follow the same plainness. A language track holds its modules
the same way for every language: a module is a non-dot folder directly under the track's root, named by the folder, and the track's own test
holder is declared on the folder place so it never resolves to a module named `tests`.
