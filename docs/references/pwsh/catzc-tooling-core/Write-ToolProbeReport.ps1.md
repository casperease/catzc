# pwsh/Tooling.Core/Write-ToolProbeReport.ps1

The renderer of the tool existence checks: it turns the probe records of `Test-Tool -PassThru` into one compact plain-text table.

## help

### synopsis

Writes a compact table of tool existence checks: where each tool was found, its version, and the timings.

### description

Renders the probe records from Test-Tool -PassThru as one plain-text table through Write-Message -NoHeader
([ADR-PWSH-ANNOUNCE-CORRECTSTREAM](../../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-correctstream)): one row
per tool with Found, Method (probe | path | none), Version against Required, VersionOk, ProbeMs and VersionMs, then the path. The header
line names the session actor the checks ran as. Writes nothing for no records. With no -Probe it checks every tool in tools.yml.

### parameter `Probe`

The probe records to render (Catzc.Base.Execution.ExecutableProbe, from Test-Tool -PassThru or Resolve-ToolExecutable). Accepts pipeline
input. Defaults to every tool in tools.yml.

### example 1

```powershell
Write-ToolProbeReport
```

### example 2

```powershell
'bash', 'go' | ForEach-Object { Test-Tool $_ -PassThru } | Write-ToolProbeReport
```
