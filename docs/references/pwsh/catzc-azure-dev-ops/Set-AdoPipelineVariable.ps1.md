# pwsh/Azure.DevOps/Set-AdoPipelineVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Sets an Azure DevOps pipeline variable via the ##vso logging command.

### description

Wraps the `##vso[task.setvariable]` command with output/secret flags and automatic no-op when running outside a pipeline.

By default, throws if the variable name contains characters that ADO silently replaces during downstream resolution (. - '). This prevents
hard-to-debug mismatches between the name you set and the name you reference. Use -SanitizeName to opt into automatic replacement instead.

When running locally (Test-IsRunningInPipeline returns false), the function logs the variable but does not emit the ##vso command.

The ##vso command is written like every other console line, through the writer chokepoint (Write-Message -NoHeader,
[ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT](../../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationstreamchokepoint)):
the host renders an information record to stdout exactly as it renders Write-Host, which is where the agent reads logging commands. Being an
ordinary record, it honours 6> redirection, and a Pester run silences it — so a test run in a pipeline never sets a real pipeline variable.

### parameter `Name`

The variable name. Must not contain . - ' unless -SanitizeName is set.

### parameter `Value`

The variable value. Empty strings are allowed so callers can clear a variable or signal "no value" to downstream jobs.

### parameter `IsOutput`

Mark as an output variable, accessible from downstream jobs via `dependencies.JobName.outputs['StepName.VariableName']`.

### parameter `IsSecret`

Mark as secret. ADO masks the value in all log output. The function also omits the value from its own Write-Message output.

### parameter `SanitizeName`

Replace . - ' with underscores instead of throwing. Use when the caller intentionally passes names with these characters (e.g.
environment.template patterns from dynamic key generation).

### example 1

```powershell
Set-AdoPipelineVariable -Name 'DeployTarget' -Value 'preprod'
```

### example 2

```powershell
Set-AdoPipelineVariable -Name 'dev_capi' -Value 'Deploy' -IsOutput
```

### example 3

```powershell
Set-AdoPipelineVariable -Name 'dev.capi' -Value 'Deploy' -SanitizeName
```

### example 4

```powershell
Set-AdoPipelineVariable -Name 'ConnectionString' -Value $connStr -IsSecret
```
