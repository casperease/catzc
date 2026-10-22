# pwsh/Catzc.Tooling.Claude/Start-ClaudeWorker.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Starts new Claude Code worker sessions, each in a terminal window of its own, in the repository root.

### description

Launches `claude --agent <Agent>` once per -Count, with `--model <Model>` only when -Model is given (otherwise the agent file's model
applies) and -Prompt as the session's first prompt. The agent and the terminal are entries in `configs/claude-worker.yml`, each default
declared once on its config type. -DryRun starts nothing and returns the planned launches (ADR-PWSH-DRYRUN-EARLYRETURNBRANCH).

### parameter `Agent`

The agent a worker starts as, a file name in `.claude/agents`. Default: claude-worker.yml's agent.

### parameter `Model`

The model the session runs on. Default: none, so the agent file's model applies.

### parameter `Prompt`

The first prompt of each session. Default: none.

### parameter `Count`

How many sessions to start, 1 to 20. Default: 1.

### parameter `Launcher`

The terminal to open: windows-terminal (a new wt.exe tab) or pwsh (a pwsh -NoExit window). Default: claude-worker.yml's launcher.

### parameter `PassThru`

Returns one record per started session: the index, agent, model, launcher, file path, argument list, working directory and command line.

### parameter `DryRun`

Starts nothing and returns the records instead.

### outputs

`[pscustomobject]` per launch under -PassThru or -DryRun, otherwise nothing.

### example 1

```powershell
Start-ClaudeWorker -Count 3 -Prompt 'Read the plan and take the next chunk.'
```
