# pwsh/Catzc.Base.Asserts/Assert-PsModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a PowerShell module is available.

### parameter `Module`

The module name to look up via Get-Module -ListAvailable.

### parameter `ErrorText`

Optional message to throw instead of the default.

### example 1

```powershell
Assert-PsModule 'Pester'
```
