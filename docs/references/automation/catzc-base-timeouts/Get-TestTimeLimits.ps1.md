# docs/references/automation/catzc-base-timeouts/Get-TestTimeLimits.ps1.md

`automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the `tests` section of timeouts.yml (TimeoutsConfig), defaults filled in, so Test-Automation's timing report
and its run-budget check read one source instead of a literal of their own
([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). LevelMs is keyed by
tier tag ([Catzc.Base.Timeouts.TestTiers]::Names, L0 to L4) in milliseconds; RunSeconds is the budget for a whole
Test-Automation run up to L3 (an L4 run is a stage of its own).
```
