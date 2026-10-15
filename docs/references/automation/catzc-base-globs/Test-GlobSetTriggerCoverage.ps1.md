# docs/references/automation/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md

`automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
native-trigger projection of the real tree
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)). Its safety property: every
member of a pipeline-bound set matches at least one ADO include pattern (Get-GlobSetTrigger), so an ADO
include-only trigger is always a SUPERSET of exact membership and can never under-trigger (miss a deploy); the
in-pipeline Test-GlobSetAffected check supplies exactness on top. Each uncovered member is an issue. (GitHub is exact
by construction: its ordered '!'-negation paths are the scan program itself.)

Whether a pipeline file declares the projected trigger is a separate quality gate (Test-AdoPipelineTriggerGlob).
```
