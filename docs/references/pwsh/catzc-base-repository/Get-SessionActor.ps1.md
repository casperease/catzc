# pwsh/Catzc.Base.Repository/Get-SessionActor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns who is running this session: Pipeline, Agent, or Person.

### description

The one answer every actor-dependent behaviour reads, so the policy lives in one place
([ADR-AUTO-TYPES-JANITORSBYCALLER](../../../adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-janitorsbycaller)). A CI/CD pipeline (Test-IsRunningInPipeline)
wins over an agent, because an agent's run inside a pipeline is still a pipeline run; otherwise an AI coding agent (Test-IsRunningAsAgent);
otherwise a person at a devbox. A person may change the machine and the repository on their own behalf — stop their stale sessions, commit
generated files — while an agent leaves both to the person, and a pipeline only asserts.

### parameter `ActorAssertIs`

Pins the expected actor: the detected actor is still returned, and a different one throws. The guard verifies, it never selects.

### outputs

`[string]` 'Pipeline', 'Agent', or 'Person'.

### example 1

```powershell
Get-SessionActor
```

### example 2

```powershell
if ((Get-SessionActor) -eq 'Person') { Sync-GeneratedFile }
```

### example 3

```powershell
$null = Get-SessionActor -ActorAssertIs Pipeline
```
