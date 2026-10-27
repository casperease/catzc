# pwsh/Base.Timeouts/Get-TimeoutSeconds.ps1

The one resolver of a time limit: every consumer of the time safeguard asks it how many seconds a call, an executable, a shell or a command
may run.

## help

### synopsis

Returns how many seconds a call may run before its time safeguard stops it.

### description

Resolves the limit from timeouts.yml for the run environment this session is in (Get-RunEnvironment: devbox or pipeline). With -Executable
it is the executable's own entry under `executables` when it has one, otherwise the environment's pwsh limit. With -Shell it is that shell's
limit: bash has a foreground and a -Background limit (the ones the Claude Code hook enforces, since the hook governs the Bash tool), and
every other engine has one. With -Command it is a function's own limit, most specific first: an exemption for its `[TimeLimit]` decoration's
budget GUID, then its entry under `commands`, then the decoration for this environment, then the environment's pwsh limit
([ADR-PWSH-ASSERT-DECLAREDTIMELIMIT](../../../drs/automation/pwsh/assert-idioms.md#rule-adr-pwsh-assert-declaredtimelimit)). Every consumer
of the safeguard (Invoke-Executable, Invoke-WithTimeout, Assert-CompletesWithin, the hook's parity test) asks here, so tuning a limit is one
edit to the config.

### parameter `Executable`

The executable the call runs. A directory and an extension are ignored (`C:\tools\dotnet.exe` resolves as `dotnet`).

### parameter `Command`

The function whose own limit to return — its `[Catzc.Base.Timeouts.TimeLimit]` decoration, unless config overrides it. The function must be
loaded, exported or private to a loaded module; a name no loaded module defines throws and points an executable to -Executable.

### parameter `Shell`

The shell whose limit to return, one of the execution engines (pwsh, bash or zsh); pwsh is the default. Any other name throws, naming the
shells.

### parameter `Background`

Return the bash background limit instead of the foreground one. Bash only.

### parameter `Budget`

The work's immutable budget GUID. When timeout-exemptions.yml exempts it here, the limit is raised to the exemption ceiling (never lowered).
Omitted (the empty GUID) means no budget.

### parameter `EnvironmentAssertIs`

Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never selects.

### example 1

```powershell
Get-TimeoutSeconds                          # the environment's pwsh limit
```

### example 2

```powershell
Get-TimeoutSeconds -Executable dotnet       # dotnet's own limit, or the environment's pwsh limit
```

### example 3

```powershell
Get-TimeoutSeconds -Shell Bash -Background  # the hook's limit for a background Bash call here
```

### example 4

```powershell
Get-TimeoutSeconds -Budget $budget          # the pwsh limit, or the exemption ceiling while $budget is exempt
```

### example 5

```powershell
Get-TimeoutSeconds -Command Test-Automation # Test-Automation's own limit, from its [TimeLimit] unless config overrides it
```

## comment:1

Above `$function = Get-Module | Where-Object { $null -ne $_.SessionState } |...`, written with `#`.

```text
A module's private function is visible only inside its own module, so each loaded module with a session state
is asked; a nested script file, such as a module's loader, has none of its own.
```
