---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-GO-MANAGEDTOOLCHAIN
      - ADR-AUTO-DEPS-PLATFORMPREREQUISITEASSERTED
---

# Go runs from a located toolchain and platform prerequisites are asserted

This article is one rule: [ADR-AUTO-GO-MANAGEDTOOLCHAIN](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-managedtoolchain) and
[ADR-AUTO-DEPS-PLATFORMPREREQUISITEASSERTED](../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-platformprerequisiteasserted)
merged into one. It holds nothing beyond what those two rules say.

A Go test run uses the managed toolchain, located through the existence check and run by its path, never a bare `go` off `PATH`, with
`GOTOOLCHAIN=local`. A platform-provided prerequisite is asserted, never installed by its own entry: the operating system, winget or
`/bin/bash` on Linux, or a base tool the devbox installs unpinned, git, and Git Bash with it.
