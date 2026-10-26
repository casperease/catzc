# pwsh/Base.Asserts/Assert-IsRunningInVsCode.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
