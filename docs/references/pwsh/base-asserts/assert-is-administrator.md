# pwsh/Base.Asserts/Assert-IsAdministrator.ps1

The throwing form of `Test-IsAdministrator`: it throws when the session is not elevated.

## help

### synopsis

Throws if the current session is not running as Administrator.

### parameter `ErrorText`

Custom error message.

### example 1

```powershell
Assert-IsAdministrator
```
