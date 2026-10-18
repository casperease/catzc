# automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that the C# types loaded in this PowerShell process are current with their sources.

### description

The throwing form of Test-LoadedTypesCurrent
([ADR-AUTO-FAILFAST#3](../../../adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast3)): a precondition
for work that must run on the types as written, such as a test of a type just edited. A loaded assembly cannot
be swapped in a running process
([ADR-AUTO-TYPES#7](../../../adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7)), so the one remedy is
a new process; the message names it, with every drifted type and both hashes or code roots.

### parameter ModulesRoot

The code root whose type sources to compare. Default: the loaded code root (Get-CatzcModulesRoot).

### example 1

```powershell
Assert-LoadedTypesCurrent
```
