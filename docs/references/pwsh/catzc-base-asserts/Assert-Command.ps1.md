# pwsh/Base.Asserts/Assert-Command.ps1

The throwing form of `Test-Command`: it throws when a named command is not available in the session.

## help

### synopsis

Asserts that a command exists on the system.

### parameter `Command`

The command name to look up via Get-Command.

### parameter `ErrorText`

Custom error message. Defaults to '`<Command>` is not installed'.

### example 1

```powershell
Assert-Command 'git'
```
