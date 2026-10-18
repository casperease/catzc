# automation/Catzc.Tooling.Python/Invoke-Pip.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs pip through uv (`uv pip`).

### description

Delegates to Invoke-Uv, so `Invoke-Pip 'install --system requests'` runs `uv pip install --system requests`
against the uv-managed Python. uv is the standard Python handler; installs that target the global
interpreter pass `--system` (see Install-PipTool). uv presence is asserted by Invoke-Uv.

### parameter Arguments

Arguments to pass to `uv pip`.

### parameter PassThru

Return a CliResult object with Output, Errors, Full, and ExitCode.

### parameter NoAssert

Skip exit code assertion.

### parameter Silent

Suppress the command log line and all console output.

### parameter DryRun

Return the command string without executing. Used for testing.

### example 1

```powershell
Invoke-Pip 'install --system requests'
```

### example 2

```powershell
Invoke-Pip 'list --format json' -DryRun
```
