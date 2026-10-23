---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED
      - ADR-AUTO-GO-GENERATEDWORKSPACE
---

# Generated manifests and the go workspace are gitignored derived artifacts

This article is one rule:
[ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-manifestsgitignored)
and [ADR-AUTO-GO-GENERATEDWORKSPACE](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-generatedworkspace) merged into one. It
holds nothing beyond what those two rules say.

Generated manifests are gitignored, never committed: `New-DynamicManifest` recomputes each module's `<Module>.psd1` on every import, writing
only when the content differs. The Go workspace is generated and gitignored in the same way: nothing Go-specific is committed but the
`*_test.go` files, and `New-GoWorkspace` renders `go.work` and every `go.mod` from `go.yml`, pure text, offline and byte-stable.
