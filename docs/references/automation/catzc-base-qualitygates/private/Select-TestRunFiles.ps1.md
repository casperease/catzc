# docs/references/automation/catzc-base-qualitygates/private/Select-TestRunFiles.ps1.md

`automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The work-list stage of a test run (Invoke-TestRun), in order:

- the test files under the test paths, in foundation-first folder order (Get-TestAutomationTestFiles);
- -Rule: only the files carrying a test that cites one of the given ADR rules (Select-RuleTaggedFiles). The worker
  also filters within a file by include tag, so a file mixing matched and other tests runs only the matched ones;
- tier and category scope: only the files holding a test in the run's scope (Select-InScopeTestFiles), so no worker
  loads a file only to skip every test in it. The dropped files' tests come back as the NotRun rows a worker would
  have returned (ConvertTo-TestAutomationRowSet), for the caller to report;
- the opt-out tag (the build run's 'source-only',
  [ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31)): its tests are excluded, files
  left with nothing to run are dropped, and every excluded test is counted and listed — never silently
  (Get-TestOptOutExclusion, Write-TestOptOutExclusion).

Throws when -Rule or the opt-out tag leaves nothing to run. Tier and category scope may leave nothing; the run is
then vacuously green, with every test reported as NotRun.
```
