# automation/Catzc.Azure.Cli/Disconnect-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Logs out of Azure CLI.

### description

Skips if not currently logged in.

### example 1

```powershell
Disconnect-AzCli
```

## comment:1

Above `$result = Invoke-Executable 'az account show --output json' -PassThru...`, written with `#`.

```text
Idempotent: skip if not logged in
-NoAssert: non-zero exit means "not logged in" — an expected state, not an error
```
