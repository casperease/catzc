# automation/Catzc.Base.Environment/Get-PermanentEnvironmentVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads an environment variable from a persistent scope (the Windows registry for User/Machine).

### description

The single seam through which tooling READS a persistent environment variable other than PATH (PATH has its own, Get-EnvironmentPath), so a
logic test can Mock the registry boundary (`Mock Get-PermanentEnvironmentVariable -ModuleName <module>`) instead of reading the real user
environment. User/Machine scopes are a Windows concept; callers guard Windows-only use with $IsWindows. The real registry round trip is
proven by the L3 system test in tests/Set-PermanentEnvironmentVariable.Tests.ps1.

### parameter `Name`

The variable's name.

### parameter `Scope`

Which persistent scope to read: User (default) or Machine.

### outputs

`[string]` the value, or $null when the variable is not set in that scope.

### example 1

```powershell
Get-PermanentEnvironmentVariable JAVA_HOME
```
