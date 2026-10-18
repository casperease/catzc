# automation/Catzc.Base.Asserts/Assert-Command.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a command exists on the system.

### parameter `Command`

The command name to look up via Get-Command.

### parameter `ErrorText`

Custom error message. Defaults to '`<Command>` is not installed'.

### example 1

```powershell
Assert-Command 'git'
```
