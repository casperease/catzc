# pwsh/Base.Drs/Test-DrsEngineNeutrality.ps1

A quality gate that keeps engine syntax and vendor names out of the rule summaries of the configured DRS domains.

## help

### synopsis

Checks that the rule summaries of the checked DRS domains carry none of the tokens of their configured token sets.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the rule
summaries (the `### Rule <code>:<n>` entries, Get-DrsRuleSummaryLines) of every rule set in the domains listed under
engine_neutrality.domains in drs-checks.yml. The engine-agnostic rules hold for every execution engine
([ADR-AUTO-ENGINE-THREEENGINES](../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)), so their summaries state a
rule, never one engine's syntax, and a vendor-neutral tier never names a vendor. Each domain names the token sets under
engine_neutrality.token_sets it is held to (engine, vendor, or both); each token is a regular expression, and every match is a finding,
reported with its file and line. Naming a catzc command is allowed, so the engine set lists engine built-ins only.

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
