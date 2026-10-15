# docs/references/automation/catzc-base-qualitygates/Test-ManualTestPlan.ps1.md

`automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) keeping
the manual test plan in step with the tests. The plan is the overview docs/how-to/automation/manual-test-plan.md
plus one category file per category (at most 13) in docs/how-to/automation/manual-test-plan/; the index rows live
in the category files. It finds every integrity-tagged Describe,
Context, and It across the test files (except the vendored ones) by PARSING them — never by Pester discovery, as a
nested Invoke-Pester inside a run is unsafe ([ADR-AUTO-TEST#16](/docs/adr/automation/test-automation.md#rule-adr-auto-test16)).
A block is integrity when its own -Tag array holds the literal 'integrity'; its identity is the pair (repository-
relative file, block name), as block names repeat across files.

The plan's index rows are the category files' markdown table rows that name a .Tests.ps1 path. Issues:

  - the category folder is missing, or holds no category file;
  - the category folder holds more than 13 category files;
  - an integrity block has no row naming both its file and its block name;
  - the row count differs from the block count (a stale or duplicate row, or a renamed or removed block).

It reads the repository's test files and the plan, which exist only in the source tree (Assert-SourceTree).
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the result ({ Subject; IssueCount; Issues; ReportPath; IntegrityBlocks; PlanRows; CategoryFiles }) instead of throwing
on issues.
```
