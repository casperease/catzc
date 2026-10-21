# pwsh/Catzc.Base.Drs/Test-DrsEngineNeutrality.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the rule summaries of the configured ADR domains carry no engine-specific syntax.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the rule
summaries (the `### Rule <code>:<n>` entries, Get-DrsRuleSummaryLines) of every rule set in the domains listed under
engine_neutrality.domains in drs-checks.yml. The engine-agnostic rules hold for every execution engine
([ADR-AUTO-ENGINE-THREEENGINES](../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)), so their summaries state a
rule, never one engine's syntax: each token under engine_neutrality.tokens is a regular expression for such syntax, and every match is a
finding, reported with its file and line. Naming a catzc command is allowed, so the tokens list engine built-ins only.

A domain in that list that drs.yml does not declare is a finding too. A rule set with no file, or several, is Test-DrsRegistry's finding and
is skipped.

The check's mode is engine_neutrality.mode (Catzc.Base.Drs.DrsChecksConfig): in gate mode the gate throws once listing every finding; in
report mode it prints the findings and their count, writes the same report, and never throws.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-drs-engine-neutrality/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Mode; Domains; RuleSets; Lines }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-DrsEngineNeutrality
```

### example 2

```powershell
(Test-DrsEngineNeutrality -PassThru).Issues
```
