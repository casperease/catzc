# pwsh/Base.QualityGates/Test-QualityGates.ps1

The one gate entry for a CI: it runs every check the language registry declares over the working root and fails on any issue.

## help

### synopsis

Runs every check the language registry declares and fails on any issue.

### description

A consumer's pipeline is this gate, then Test-Automation
([ADR-AUTO-CONSUMER-CATZCGATES](../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-catzcgates)). It keeps no list of
gates of its own: the set is the union of the `checks` of every file language in languages.yml that a tracked file of the working root
resolves to (a check that `check_scopes` ties to a folder needs that folder to exist), the same set Measure-QualityGates times
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)). Each
gate runs once with -PassThru, and writes its own report as it does when called alone.

Collects every issue, each one named with its gate, and ends with Write-QualityGateReport
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): the report lands in
out/test-quality-gates/, and the gate throws once listing every issue (or returns the result with -PassThru). A gate that throws, such as
one whose tool is not installed, is one issue carrying its message, which names the install command, and the run goes on to the next gate. A
check the registry names that no command defines is one issue too. The scope is the working root's tracks, so the gate runs in the catzc
source tree and in a consumer root alike (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-quality-gates).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Facts } instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-QualityGates
```

### example 2

```powershell
(Test-QualityGates -PassThru).Issues
```
