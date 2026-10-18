# automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every shipped C# type resolves in the session as `<module>.<basename>`.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the shipped
C# types: each `<module>/types/<Name>.cs` under the loaded code root (Get-CatzcModulesRoot — the source tree or a built
package) declares the type `<module>.<Name>`, so after import that full name must resolve. A file that compiles to a
differently named type, or a module whose types never loaded, is an issue. So is a concrete class that still
renders as its full name in pwsh ("$x", `[string]$x`): it must override ToString(), normally by delegating to
Catzc.Base.Objects.ConsoleText (Test-ConsoleReadyType). The formatting of the files (file-scoped namespaces) is
Test-Formatting's.

### parameter OutputFolder

The report base folder. Defaults to out/test-shipped-types/ (Write-QualityGateReport).

### parameter PassThru

Return the result ({ Subject; IssueCount; Issues; ReportPath; Types }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-ShippedTypes
```
