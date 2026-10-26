# pwsh/Base.Execution/Resolve-EngineExecutable.ps1

Returns the full path of an execution engine's executable on this machine, by the way the engine's model says to locate it.

## help

### synopsis

Returns the full path of an execution engine's executable on this machine.

### description

Locates the engine's executable the way its model says (ExecutionEngine.Locate,
[ADR-AUTO-ENGINE](../../../drs/automation/execution-engines.md)):

```text
ps-home  pwsh, beside the PowerShell that is running ($PSHOME), so a started engine is the same PowerShell as
         the caller, never another pwsh that comes first on PATH;
tool     the POSIX engines, through their tools.yml entries and the existence check (Resolve-ToolExecutable): Git
         Bash and the zsh installed into its tree on Windows, the system shell elsewhere, never the WSL launcher.
```

Throws, naming the engine and the remedy, when the executable is missing or a tool-located one misses its pin.

### parameter `Engine`

The engine's name (pwsh, bash or zsh).

### outputs

`[string]` The executable's full path.

### example 1

```powershell
& (Resolve-EngineExecutable -Engine pwsh) @((Get-ExecutionEngine -Name pwsh).StartArguments($entry, 'Get-RepositoryRoot'))
```

## Two ways to locate

`pwsh` is found beside the running PowerShell, so a started engine is the same PowerShell as its caller and never another `pwsh` that comes
first on PATH. The POSIX engines go through their `tools.yml` entries and the existence check, which on Windows means Git Bash and the zsh
installed into its tree, never the WSL launcher.
