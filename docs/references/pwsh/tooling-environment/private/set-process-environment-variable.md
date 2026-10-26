# pwsh/Tooling.Environment/private/Set-ProcessEnvironmentVariable.ps1

The private seam through which `Write-EnvironmentSet` writes and restores process environment variables. It wraps one .NET call and nothing
else, so tests mock it rather than touch the real process environment.

## help

### synopsis

Sets or removes a process-scope environment variable — the mockable I/O boundary for Write-EnvironmentSet.

### description

The single seam through which Write-EnvironmentSet WRITES and restores
$env: values, wrapping
`[Environment]::SetEnvironmentVariable(name`, value, 'Process'). A $null value removes the variable (this is how a
scoped restore returns a previously-unset variable to unset). Tests mock this boundary
(`Mock Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment`) instead of mutating the real process environment. This is the
deliberately thin, un-mockable I/O boundary, so it has no unit test of its own (mirrors Set-EnvironmentPath).

### parameter `Name`

The environment variable name to write.

### parameter `Value`

The value to set. $null removes the variable.

### example 1

```powershell
Set-ProcessEnvironmentVariable -Name 'GH_TOKEN' -Value $plaintext
```
