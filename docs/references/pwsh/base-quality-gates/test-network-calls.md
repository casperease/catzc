# pwsh/Base.QualityGates/Test-NetworkCalls.ps1

The gate over the network-call registry: it checks `network-calls.yml` against the tracked code.

## help

### synopsis

Checks the network-call registry against the tracked code, every call in a registered file and every registered site still making its call,
and reports every default-path site.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the site
registry of [ADR-AUTO-NET-REGISTRYGATE](../../../drs/automation/network-calls.md#rule-adr-auto-net-registrygate). It reads the
`network-calls` config of Base.Execution and the tracked files (Get-GitTrackedPath), and lists every issue:

- a line of tracked code that matches one of the registry's `patterns` in a file that holds no registered site;
- a registered site whose file is not tracked;
- a registered site whose file matches no pattern any more;
- a registered site whose file no longer names its function or job, the part of the key after `#`;
- a site with trigger `default-path`, an open violation of
  [ADR-AUTO-NET-NODEFAULTPATH](../../../drs/automation/network-calls.md#rule-adr-auto-net-nodefaultpath).

A line whose first text is `#` or `//` is a comment and never matches. A file on the config's `skip` paths is not searched: the tests mock
their calls, and docs, configs and contracts name a call without making it. A registered site's own file is still checked, wherever it sits.
A binary file is never read. It needs the source tree, since it reads the git index.

### parameter `Config`

The registry. Defaults to the shipped `network-calls` config.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-network-calls` (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Files; Scanned; Sites; Patterns }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-NetworkCalls
```
