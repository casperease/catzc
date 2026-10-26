# pwsh/Base.Asserts/Assert-IsAdministrator.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Throws if the current session is not running as Administrator.

### parameter `ErrorText`

Custom error message.

### example 1

```powershell
Assert-IsAdministrator
```
