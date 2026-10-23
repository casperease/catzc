---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED
      - ADR-AUTO-TEST-SOURCEONLYTAG
---

# Generated manifests are gitignored and a source only test reads only the repository files (ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED + ADR-AUTO-TEST-SOURCEONLYTAG)

This article is one rule:
[ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-manifestsgitignored)
and [ADR-AUTO-TEST-SOURCEONLYTAG](../../drs/automation/test-automation.md#rule-adr-auto-test-sourceonlytag) merged into one. It holds
nothing beyond what those two rules say.

Generated manifests are gitignored, never committed: `New-DynamicManifest` recomputes each `<Module>.psd1` from the filesystem on every
import, writing only when the content differs, so `pwsh/**/*.psd1` is a derived artifact. The tag `source-only` marks the matching kind of
test, an integrity test that reads only the repository's files, whose answer cannot differ between modes; the build run counts and lists
every test it excludes this way.
