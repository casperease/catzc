---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEPS-ASSERTBEFOREINVOKE
      - ADR-AUTO-ENGINE-IMPORTERENTRY
---

# Assert the tool before every call and reach catzc through the importer entry

This article is one rule:
[ADR-AUTO-DEPS-ASSERTBEFOREINVOKE](../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-assertbeforeinvoke) and
[ADR-AUTO-ENGINE-IMPORTERENTRY](../../drs/automation/execution-engines.md#rule-adr-auto-engine-importerentry) merged into one. It holds
nothing beyond what those two rules say.

Before every external tool call, `Assert-Tool` runs `Assert-Command` and `Assert-ToolVersion`, checking presence and version only, or for a
tool with candidate paths the fast, timed `Resolve-ToolExecutable` check, which probes those paths and PATH before starting any process.
Each engine reaches catzc through its importer entry at the repository root. The POSIX engines share the one generated, committed
`importer.sh`, which defines one dispatcher, `cats`: with no arguments it lists the catzc commands, otherwise it runs its first argument as
a catzc command in pwsh with the PowerShell entry loaded.
