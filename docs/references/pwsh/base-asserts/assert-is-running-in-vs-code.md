# pwsh/Base.Asserts/Assert-IsRunningInVsCode.ps1

The throwing check that the session runs in a VS Code terminal; it asks `Test-IsRunningInVsCode` and throws on a no.

## help

### synopsis

Throws if the current session does not run in a terminal VS Code opened. The answer comes from `Test-IsRunningInVsCode`, the loader's one
reader of VS Code's terminal mark, which the importer also asks before it decides how a stale types assembly is handled.

### parameter `ErrorText`

Custom error message.

### example 1

```powershell
Assert-IsRunningInVsCode
```
