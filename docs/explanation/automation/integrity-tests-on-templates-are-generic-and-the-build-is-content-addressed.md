---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-GENERICTEMPLATETESTS
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# Integrity tests on templates are generic and the build is content addressed

This article is one rule:
[ADR-AUTO-TEST-GENERICTEMPLATETESTS](../../drs/automation/test-automation.md#rule-adr-auto-test-generictemplatetests) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

An integrity test that exercises shipped templates must be generic: discover the set with `Get-BicepTemplateNames` or `Get-BicepTemplates`
and assert invariants that hold for every template, never binding to a specific production template name. The build those templates ship in
is immutable and content-addressed, the same commit yielding a byte-identical build on any machine.
