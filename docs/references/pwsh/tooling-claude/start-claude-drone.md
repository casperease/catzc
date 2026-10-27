# pwsh/Tooling.Claude/Start-ClaudeDrone.ps1

The public command that opens new Claude Code drone sessions, one terminal window each, in the repository root. The agent and the terminal
come from `configs/claude-drone.yml`; the launch itself is built by the private `Get-ClaudeDroneLaunch`, and `-DryRun` returns the planned
command lines instead of starting anything.

## help

### synopsis

Starts new Claude Code drone sessions, each in a terminal window of its own, in the repository root.

### description

Launches `claude --agent <Agent>` once per -Count, with `--model <Model>` only when -Model is given (otherwise the agent file's model
applies) and -Prompt as the session's first prompt. The agent and the terminal are entries in `configs/claude-drone.yml`, each default
declared once on its config type. -DryRun starts nothing and returns the planned command lines (ADR-PWSH-DRYRUN-EARLYRETURNBRANCH).

### parameter `Skill`

The job skill the drone runs, a folder in `.claude/skills`. Its `model_floor` picks the drone (Resolve-ClaudeSkillDrone), and the brief
names it first, as `skill: <name>`.

### parameter `Model`

The model the session runs on. Default: none, so the agent file's model applies.

### parameter `Prompt`

The first prompt of each session. Default: none.

### parameter `Count`

How many sessions to start, 1 to 20. Default: 1.

### parameter `Launcher`

The terminal to open: windows-terminal (a new wt.exe tab) or pwsh (a pwsh -NoExit window). Default: claude-drone.yml's launcher.

### parameter `PassThru`

Returns the command line of each started session.

### parameter `DryRun`

Starts nothing and returns the command lines instead.

### outputs

`[string[]]` under -PassThru or -DryRun: one exact command line per launch. Otherwise nothing.

### example 1

```powershell
Start-ClaudeDrone -Count 3 -Prompt 'Read the plan and take the next chunk.'
```
