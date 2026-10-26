# pwsh/Tooling.Core/Invoke-Uv.ps1

The wrapper that runs uv, the standard Python handler, after asserting that uv is installed at the locked version.

## help

### synopsis

Runs uv with the given arguments.

### description

Asserts that uv is installed at the locked version before executing. uv is the standard Python handler — it provisions Python (`uv python`)
and runs Python-based CLIs in isolated environments (`uv tool`, `uv pip`, `uv run`).

### parameter `Arguments`

Arguments to pass to uv.

### parameter `Prerelease`

Append `--prerelease=allow`, permitting pre-release/dev dependency versions in the resolution. This is a deliberate, surfaced choice — it
emits a warning — because it pulls dev-marked packages into an otherwise version-locked install (e.g. the Azure CLI pins beta `azure-*`
dependencies). Never enable it silently.

### parameter `PassThru`

Return a CliResult object with Output, Errors, Full, and ExitCode.

### parameter `NoAssert`

Skip exit code assertion.

### parameter `Silent`

Suppress the command log line.

### parameter `DryRun`

Return the command string without executing. Used for testing.

### example 1

```powershell
Invoke-Uv 'tool install azure-cli'
```

### example 2

```powershell
Invoke-Uv 'pip install azure-cli' -Prerelease
```

## Pre-release versions

Pre-release resolution is a deliberate, config-driven relaxation of the version lock, so the wrapper surfaces it and never lets it pass
silently. It is a message, not a warning: the toolchain runs with `WarningPreference=Stop`, and an opted-in pre-release is expected
behaviour, not an anomaly to halt on.
