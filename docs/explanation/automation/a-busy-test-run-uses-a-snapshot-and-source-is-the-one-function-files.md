---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-RUNSNEVERWAIT
      - ADR-PWSH-ONEFUNC-GOVERNSSOURCE
---

# A busy test run uses a snapshot and source is the one function files

This article is one rule: [ADR-AUTO-TEST-RUNSNEVERWAIT](../../drs/automation/test-automation.md#rule-adr-auto-test-runsneverwait) and
[ADR-PWSH-ONEFUNC-GOVERNSSOURCE](../../drs/automation/pwsh/one-function-per-file.md#rule-adr-pwsh-onefunc-governssource) merged into one. It
holds nothing beyond what those two rules say.

A test run never waits for another: the first run owns the working folder and runs in place, and a run that starts while another holds it
runs in a verified snapshot of the working folder instead. What both run is source under `pwsh/<Module>/`; the installed build's merged
`<Module>.functions.ps1` is a generated artifact of `Build-Modules`, derived from the one-function source files.
