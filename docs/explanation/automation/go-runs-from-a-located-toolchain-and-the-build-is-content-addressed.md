---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-GO-MANAGEDTOOLCHAIN
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# Go runs from a located toolchain and the build is content addressed

This article is one rule: [ADR-AUTO-GO-MANAGEDTOOLCHAIN](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-managedtoolchain) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

A Go test run uses the managed toolchain, located through the existence check (`Resolve-ToolExecutable`) and run by its path, never a bare
`go` off `PATH`, with `GOTOOLCHAIN=local` so it never switches to a toolchain it downloads itself. The build is immutable and
content-addressed: the same commit yields a byte-identical build on any machine.
