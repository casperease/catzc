---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEPS-ASSERTBEFOREINVOKE
      - ADR-AUTO-GO-MANAGEDTOOLCHAIN
---

# Tools are asserted before every call and go runs from a located managed toolchain

This article is one rule:
[ADR-AUTO-DEPS-ASSERTBEFOREINVOKE](../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-assertbeforeinvoke) and
[ADR-AUTO-GO-MANAGEDTOOLCHAIN](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-managedtoolchain) merged into one. It holds
nothing beyond what those two rules say.

Assert before every invocation: `Assert-Tool` runs `Assert-Command` and `Assert-ToolVersion`, or for a tool whose entry declares candidate
paths the fast, timed `Resolve-ToolExecutable` check. A Go test run applies it to its toolchain: the managed toolchain is located through
that existence check and run by its path, never a bare `go` off `PATH`, with `GOTOOLCHAIN=local` so it never switches to a toolchain it
downloads itself.
