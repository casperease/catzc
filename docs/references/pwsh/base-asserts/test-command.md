# pwsh/Base.Asserts/Test-Command.ps1

The query form that answers whether a named command exists in the session; `Assert-Command` is its throwing form.

## help

### synopsis

Tests whether a command exists in the current session.

### parameter `Command`

The command name to check.

### example 1

```powershell
Test-Command 'git'
```
