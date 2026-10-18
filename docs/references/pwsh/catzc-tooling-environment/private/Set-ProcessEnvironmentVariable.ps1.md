# pwsh/Catzc.Tooling.Environment/private/Set-ProcessEnvironmentVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
