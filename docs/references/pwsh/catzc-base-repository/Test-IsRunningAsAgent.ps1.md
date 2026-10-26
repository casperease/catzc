# pwsh/Base.Repository/Test-IsRunningAsAgent.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns true if the current session is driven by an AI coding agent rather than a person.

### description

Detects an agent-run shell by the environment variables the agent sets for the processes it spawns: Claude Code sets CLAUDECODE=1, and agent
harnesses set AI_AGENT. The distinction is who owns the machine's other sessions: a person may stop their own stale processes, an agent must
not stop the person's — it works with what it loaded itself.

### example 1

```powershell
Test-IsRunningAsAgent
```

### example 2

```powershell
if (-not (Test-IsRunningAsAgent)) { Clear-ModuleTypeCache -StopLockingProcesses }
```
