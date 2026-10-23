---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS
      - ADR-BCL-TYPES-CONSOLEVERIFIESONLY
---

# A secret reaches a child process through one seam and a console import loads nothing

This article is one rule:
[ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS](../../drs/automation/environment-variables.md#rule-adr-auto-envvar-secrettochildprocess) and
[ADR-BCL-TYPES-CONSOLEVERIFIESONLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-consoleverifiesonly) merged into one.
It holds nothing beyond what those two rules say.

Boundaries are crossed through one seam each. A secret goes to a child process through the environment only via `Write-EnvironmentSet`, as a
protected value, masked as `***` in logs, decrypted only when set, and scoped and restored by default. In a console session the importer
likewise verifies the types assembly and loads nothing: `Import-CSharpTypes` registers it as deferred and the first lookup of a catzc
command loads it, while a headless session loads at import so a stale assembly fails where it starts.
