# pwsh/Base.QualityGates/Test-ManualTestPlan.ps1

The gate over the manual test plan: it checks that the plan lists every integrity check, once.

## help

### synopsis

Quality gate: the manual test plan lists every integrity check, once.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) keeping the manual
test plan in step with the tests. The plan is the overview docs/how-to/pwsh/manual-test-plan.md plus one category file per category (at
most 13) in docs/how-to/pwsh/manual-test-plan/; the checks live in the category files. It finds every integrity-tagged Describe, Context,
and It across the test files (except the vendored ones) by PARSING them — never by Pester discovery, as a nested Invoke-Pester inside a run
is unsafe ([ADR-AUTO-TEST-INTEGRITYREADSFILES](../../../drs/automation/test-automation.md#rule-adr-auto-test-integrityreadsfiles)). A block
is integrity when its own -Tag array holds the literal 'integrity'; its identity is the pair (repository- relative file, block name), as
block names repeat across files.

The plan's checks are the category files' "### N." sections, each read with its **Test file:** line, which names the test file and the
block. Issues:

- the category folder is missing, or holds no category file;
- the category folder holds more than 13 category files;
- a check section has no **Test file:** line;
- an integrity block has no check naming both its file and its block name;
- the check count differs from the block count (a stale or duplicate check, or a renamed or removed block).

It reads the repository's test files and the plan, which exist only in the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-manual-test-plan/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; IntegrityBlocks; PlanChecks; CategoryFiles }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-ManualTestPlan
```

## Reading the plan

One check is one "### N." section: its heading and its "**Test file:**" paragraph, which names the test file and the block. The formatter
wraps a long paragraph, so the paragraph runs to the next blank line.
