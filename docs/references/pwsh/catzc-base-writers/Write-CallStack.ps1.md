# pwsh/Base.Writers/Write-CallStack.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes the current call stack in red for debugging.

### example 1

```powershell
Write-CallStack
```
