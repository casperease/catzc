---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEPM-GROUPAWAREINTEGRITY
      - ADR-AUTO-TEST-QUALITYGATE
---

# Dependency integrity is group aware and a quality gate collects every issue

This article is one rule:
[ADR-AUTO-DEPM-GROUPAWAREINTEGRITY](../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-groupawareintegrity) and
[ADR-AUTO-TEST-QUALITYGATE](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate) merged into one. It holds nothing beyond
what those two rules say.

Dependency integrity is group-aware and fails fast. At load, the `DependenciesConfig` type checks the declaration's shape: every target
resolves to a declared module or group, each group is closed over its own members, and the module graph and each group's internal DAG are
acyclic. Against the real repository, the `Test-ModuleDependency` quality gate collects every issue and throws once listing them all.
