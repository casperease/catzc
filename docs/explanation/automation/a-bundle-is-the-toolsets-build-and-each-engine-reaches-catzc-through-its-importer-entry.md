---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BUNDLE-BUNDLEISBUILD
      - ADR-AUTO-ENGINE-IMPORTERENTRY
---

# A bundle is the toolsets build and each engine reaches catzc through its importer entry

This article is one rule: [ADR-AUTO-BUNDLE-BUNDLEISBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-bundleisbuild) and
[ADR-AUTO-ENGINE-IMPORTERENTRY](../../drs/automation/execution-engines.md#rule-adr-auto-engine-importerentry) merged into one. It holds
nothing beyond what those two rules say.

A bundle is the toolset's build: one installable, versioned `Catzc` package of one named bundle, an `exporter.yml` `bundles` entry with its
own profile, version line and vendor policy, under `out/pwsh/built/<bundle>/Catzc/<version>/`. Each engine reaches catzc through its
importer entry at the repository root, the POSIX engines sharing the one generated, committed `importer.sh`.
