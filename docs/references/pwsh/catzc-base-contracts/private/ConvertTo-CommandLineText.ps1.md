# pwsh/Base.Contracts/private/ConvertTo-CommandLineText.ps1

The joiner that turns an executable and its arguments into one command-line string. It exists so a runner and the process starter agree on
how the arguments split.

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
