# pwsh/Catzc.Base.Drs/Test-DrsRegistry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the ADR registry (drs.yml) and the ADR rule files under docs/drs/ agree.

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

The registry's own invariants (unique external codes, domain links that are declared and acyclic) are DrsConfig construction rules, not
this gate's.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-adr-registry/ (Write-QualityGateReport); a check in report mode writes under
`<OutputFolder>/adr-<check>/` when it is given, else under its own default folder.

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

## comment:1

Above `$configured = @(`, written with `#`.

```text
The configured checks: one mode setting each, the same handling for both
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).
```
