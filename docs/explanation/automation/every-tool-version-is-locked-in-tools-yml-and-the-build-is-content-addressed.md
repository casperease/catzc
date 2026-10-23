---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEPS-LOCKEDTOOLVERSIONS
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# Every tool version is locked in tools yml and the build is content addressed

This article is one rule:
[ADR-AUTO-DEPS-LOCKEDTOOLVERSIONS](../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-lockedtoolversions) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

Lock every tool version in `pwsh/Catzc.Base.Execution/configs/tools.yml`: pinned tools install an explicit, reviewable version, and a small
allowlist of base tools (git, vscode) deliberately tracks `latest` and verifies integrity against the publisher's published hash. The build
is held to the same reproducibility: it is immutable and content-addressed, so the same commit yields a byte-identical build on any machine
and an identical durable-SHA content hash.
