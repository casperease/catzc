# pwsh/Base.Repository/Test-IsRunningAsAgent.ps1

The query that answers whether an AI coding agent drives the session, read off the environment variables the agent sets.

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
