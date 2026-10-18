# pwsh/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the rule summaries of the configured ADR domains carry no engine-specific syntax.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the rule summaries (the
`### Rule <code>:<n>` entries, Get-AdrRuleSummaryLines) of every rule set in the domains listed under engine_neutrality.domains in
adr-checks.yml. The engine-agnostic rules hold for every execution engine
([ADR-AUTO-ENGINE#1](../../../adr/automation/execution-engines.md#rule-adr-auto-engine1)), so their summaries state a rule, never one
engine's syntax: each token under engine_neutrality.tokens is a regular expression for such syntax, and every match is a finding, reported
with its file and line. Naming a catzc command is allowed, so the tokens list engine built-ins only.

A domain in that list that adrs.yml does not declare is a finding too. A rule set with no file, or several, is Test-AdrRegistry's finding
and is skipped.

The check's mode is engine_neutrality.mode (Catzc.Base.Docs.AdrChecksConfig): in gate mode the gate throws once listing every finding; in
report mode it prints the findings and their count, writes the same report, and never throws.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-adr-engine-neutrality/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Mode; Domains; RuleSets; Lines }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-AdrEngineNeutrality
```

### example 2

```powershell
(Test-AdrEngineNeutrality -PassThru).Issues
```
