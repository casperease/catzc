---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-GO-MODULESBYLAYOUT
      - ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES
---

# Go modules exist by layout and code languages select the modules in the mix

This article is one rule: [ADR-AUTO-GO-MODULESBYLAYOUT](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-modulesbylayout) and
[ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES](../../drs/automation/importer.md#rule-adr-auto-importer-codelanguagesselectmodules) merged
into one. It holds nothing beyond what those two rules say.

Go code in the repository is either a module of the `go` track, a folder under the Go root that exists by the layout, or a black-box test
under the track's test holder; a Go module ships only what `files.yml` packages. A module's code languages are the executable languages of
the files that a language's own layout row places, the shared rows, assets and tests, never counting, and a module is in the mix when every
code language of it is.
