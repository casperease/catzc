# pwsh/Catzc.Base.Environment/Set-PermanentEnvironmentVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes, or removes, an environment variable in a persistent scope (the Windows registry for User/Machine).

### description

The single seam through which tooling WRITES a persistent environment variable other than PATH (PATH has its own, Set-EnvironmentPath), so a
logic test can Mock the registry boundary (`Mock Set-PermanentEnvironmentVariable -ModuleName <module>`) instead of changing the real user
environment, which every other process and every concurrent test run on the machine shares. User/Machine scopes are a Windows concept;
callers guard Windows-only use with $IsWindows.

Because every such write passes through here, this is also where it is announced
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../adr/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)): one line names the scope, the variable
and the change. Writing the value the scope already holds — or removing a variable that is not set — is a no-op, so it neither writes nor
announces.

This is the thin I/O boundary itself, so its test is the vertical system test (L3): a real round trip through the user environment.

### parameter `Name`

The variable's name.

### parameter `Value`

The value to persist. $null or empty removes the variable from the scope.

### parameter `Scope`

Which persistent scope to write: User (default) or Machine.

### example 1

```powershell
Set-PermanentEnvironmentVariable JAVA_HOME 'C:\jdk-21'
```

### example 2

```powershell
Set-PermanentEnvironmentVariable JAVA_HOME $null   # remove it
```

## comment:1

Above `[System.Environment]::SetEnvironmentVariable($Name, [NullString]::Value, $Scope)`, written with `#`.

```text
PowerShell hands $null to a .NET string parameter as '', which the scopes the registry backs store as an empty value;
only a real null deletes it.
```
