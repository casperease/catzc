# pwsh/Catzc.Base.Repository/Get-RunEnvironment.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns where this session runs: Pipeline or Devbox.

### description

The environment axis of devbox/pipeline parity ([ADR-AUTO-PARITY](../../../drs/automation/devbox-pipeline-parity.md)), read off the one
seam, Test-IsRunningInPipeline. It answers where the run happens; who drives it (a person or an agent) is Get-SessionActor's question.
Environment-dependent settings, such as the time-safeguard limits, key on this.

### parameter `EnvironmentAssertIs`

Pins the expected environment: the detected one is still returned, and a different one throws. The guard verifies, it never selects.

### outputs

`[string]` 'Pipeline' or 'Devbox'.

### example 1

```powershell
Get-RunEnvironment
```

### example 2

```powershell
$null = Get-RunEnvironment -EnvironmentAssertIs Devbox
```
