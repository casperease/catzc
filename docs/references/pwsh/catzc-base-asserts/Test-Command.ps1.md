# pwsh/Base.Asserts/Test-Command.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether a command exists in the current session.

### parameter `Command`

The command name to check.

### example 1

```powershell
Test-Command 'git'
```
