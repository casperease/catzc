# pwsh/Base.Drs/Test-DrsRegistry.ps1

A quality gate that checks the DRS registry and the decision records agree, and runs the configured citation-graph and DORA-coverage checks.

## help

### synopsis

Checks that the DRS registry (drs.yml) and the decision records agree.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the ADR
registry (Get-Config -Config drs, an DrsConfig) and the ADR files it registers. An ADR rule file is a `docs/drs/**/*.md` that declares a
`## Rules: <code>` registry; the other files there (the generated index and glossary, each domain's dora-explains.md, a folder's index.md or
README.md) carry none and are out of scope. It collects an issue when:

- a rule set has no file `docs/drs/<domain>/**/<slug>.md`, or more than one;
- a rule set's file does not head its registry `## Rules: <External>` with the registered external code;
- a rule file is registered by no rule set (its `<domain folder>/<slug>` is not in drs.yml).

It also runs two checks whose mode is configured in drs-checks.yml (Catzc.Base.Drs.DrsChecksConfig):

- citation graph (citation_graph): an ADR page cites only its own domain or a domain in its domain's depends_on
  (Get-DrsCitationGraphViolations);
- DORA coverage (dora_coverage): every rule set whose domain is not exempt has exactly one section linking its ADR in its domain's DORA file
  (Get-DrsDoraCoverageViolations).

A check in gate mode adds its findings to this gate's issues. A check in report mode writes its own report (`out/test-adr-<check>/`,
Write-QualityGateReport), prints its findings and their count, and never fails the run.

The registry's own invariants (unique external codes, domain links that are declared and acyclic) are DrsConfig construction rules, not this
gate's.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-drs-registry/ (Write-QualityGateReport); a check in report mode writes under
`<OutputFolder>/drs-<check>/` when it is given, else under its own default folder.

### parameter `PassThru`

Return the result instead of throwing on issues: { Subject; IssueCount; Issues; ReportPath; RuleSets; Files; CitationGraphMode;
CitationGraphFindings; DoraCoverageMode; DoraCoverageFindings; CitationGraph; DoraCoverage }, where CitationGraph and DoraCoverage list each
check's findings in either mode.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-DrsRegistry
```

## Configured checks

The citation-graph and DORA-coverage checks each have one mode setting, and both get the same handling
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).

## Page keys

The file index gives each page a key, so a page under a domain folder that points into another domain's folder is checked against its own
domain.

## Report folder

A check in report mode writes its own report under the caller's folder when `-OutputFolder` is given, else under its subject's default.
