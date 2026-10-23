---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-FEWINTEGRATIONTESTS
      - ADR-PWSH-ONEFUNC-GOVERNSSOURCE
---

# One integration thread proves the wiring and installed builds merge one function files by generation (ADR-AUTO-TEST-FEWINTEGRATIONTESTS + ADR-PWSH-ONEFUNC-GOVERNSSOURCE)

This article is one rule:
[ADR-AUTO-TEST-FEWINTEGRATIONTESTS](../../drs/automation/test-automation.md#rule-adr-auto-test-fewintegrationtests) and
[ADR-PWSH-ONEFUNC-GOVERNSSOURCE](../../drs/automation/pwsh/one-function-per-file.md#rule-adr-pwsh-onefunc-governssource) merged into one. It
holds nothing beyond what those two rules say.

Keep a very few integration tests, one per distinct integration concern, and prove the boundary connects once. The build follows the same
economy for source: the one-function `.ps1` files under `pwsh/<Module>/` are the source, and the installed build's merged
`<Module>.functions.ps1` is a generated artifact of `Build-Modules`, never edited by hand and never checked in; the build asserts the
one-function rule on its input and fails when a source file breaks it.
