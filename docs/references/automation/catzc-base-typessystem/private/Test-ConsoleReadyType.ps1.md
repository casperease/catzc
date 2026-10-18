# automation/Catzc.Base.TypesSystem/private/Test-ConsoleReadyType.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Whether a shipped C# type renders as one readable line in pwsh, rather than as its full name.

### description

PowerShell's "$x" and `[string]$x` call the type's own .NET ToString() and ignore an ETS ToString, so a type
reads well in pwsh only when it overrides ToString() — normally by delegating to
Catzc.Base.Objects.ConsoleText (`public override string ToString() => this.ToConsoleString();`), which every
DictionaryRecord inherits. A type that is never held as a value needs no override and passes: an enum (it
renders its name), an interface, a delegate, an abstract or static class, an Attribute, and an Exception (it
renders its message).

### parameter Type

The loaded type to check.

### outputs

`[bool]` True when the type is console-ready or exempt.

### example 1

```powershell
Test-ConsoleReadyType -Type ([Catzc.Base.Objects.ArtifactRef])
```
