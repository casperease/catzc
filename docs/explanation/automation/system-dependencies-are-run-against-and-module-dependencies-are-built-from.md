---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEPS-TWODEPENDENCYKINDS
      - ADR-AUTO-DEPM-NOTSYSTEMDEPENDENCY
---

# System dependencies are run against and module dependencies are built from

This article is one rule:
[ADR-AUTO-DEPS-TWODEPENDENCYKINDS](../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-twodependencykinds) and
[ADR-AUTO-DEPM-NOTSYSTEMDEPENDENCY](../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-notsystemdependency) merged
into one. It holds nothing beyond what those two rules say.

Two kinds of dependency, two names. A system dependency (`ADR-AUTO-DEPS`) is an external runtime or CLI the automation runs against, such as
`pwsh`, Python, `dotnet`, the Azure CLI or git, installed at the OS level and covered by the Tooling layer. A module dependency
(`ADR-AUTO-DEPM`) is an edge among the repository's own modules, code it builds from, declared in `dependencies.yml` and pinned and stitched
into the build. Keep the two names distinct in code, config and prose.
