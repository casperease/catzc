---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-BCL-TYPES-CHANGEDAFTERLOAD
      - ADR-AUTO-ENGINE-IMPORTERENTRY
---

# Changed types are handled by context and each engine has an importer entry

This article is one rule:
[ADR-BCL-TYPES-CHANGEDAFTERLOAD](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-changedafterload) and
[ADR-AUTO-ENGINE-IMPORTERENTRY](../../drs/automation/execution-engines.md#rule-adr-auto-engine-importerentry) merged into one. It holds
nothing beyond what those two rules say.

A loaded assembly cannot be swapped in a running process, so changed-after-load is handled by context: in a pipeline the loader throws,
since CI must never run on stale types, and on a devbox a changed or removed type degrades gracefully, the loader warning that it is using
the old cached types until the session restarts. Each engine reaches catzc through its importer entry at the repository root.
