# docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationHeader.ps1.md

`automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Renders a single Write-Header (a self-contained curved box) naming the run's scope: its tier range, plus
the category and the module list when either is narrowed from the defaults. Test-Automation calls this
before it sets the writers' suppression flag, so the banner renders and everything the run then emits —
Pester's own lines, and the timing / report / skip sections below — sits under it.
```

## comment:2

Section `.PARAMETER Title` of the comment-based help.

```text
The run's name on the banner: "Test Automation" (the source run, the default) or the build run's
"Catzc Build Run" ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)).
```
