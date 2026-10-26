# pwsh/Base.Contracts/private/ConvertTo-CommandLineText.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes an executable and its arguments as one command line that splits back into the same arguments.

### description

Each part is wrapped in double quotes and an inner double quote is escaped as `\"`, the form CliRunner splits back into the same arguments.
The parts are joined by single spaces, the executable first.

### parameter `Executable`

The executable the line starts.

### parameter `Argument`

The arguments, in order; may be empty.

### outputs

`[string]` The command line.

### example 1

```powershell
ConvertTo-CommandLineText -Executable pwsh -Argument '-NoProfile', '-Command', 'Get-Widget'
```

## comment:1

Above `@(foreach ($item in @($Executable) + $Argument) {`, written with `#`.

```text
The command line CliRunner splits back into the same arguments: each in double quotes, an inner quote escaped as
\".
```
