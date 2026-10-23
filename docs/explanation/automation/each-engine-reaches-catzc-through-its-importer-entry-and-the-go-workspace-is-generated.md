---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENGINE-IMPORTERENTRY
      - ADR-AUTO-GO-GENERATEDWORKSPACE
---

# Each engine reaches catzc through its importer entry and the go workspace is generated (ADR-AUTO-ENGINE-IMPORTERENTRY + ADR-AUTO-GO-GENERATEDWORKSPACE)

This article is one rule: [ADR-AUTO-ENGINE-IMPORTERENTRY](../../drs/automation/execution-engines.md#rule-adr-auto-engine-importerentry) and
[ADR-AUTO-GO-GENERATEDWORKSPACE](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-generatedworkspace) merged into one. It holds
nothing beyond what those two rules say.

Each engine reaches catzc through its importer entry at the repository root; the POSIX engines share the one generated, committed
`importer.sh`. Generated entry points stay out of the source: the Go workspace is generated and gitignored, nothing Go-specific is committed
but the `*_test.go` files, and `New-GoWorkspace` renders `go.work` and every `go.mod` from `go.yml` as pure, offline, byte-stable text.
