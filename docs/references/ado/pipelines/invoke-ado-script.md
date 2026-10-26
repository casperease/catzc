# .ado/pipelines/Invoke-AdoScript.ps1

The one entry point every pipeline step uses to run a catzc command. The `invoke-automation.yaml` step template dot-sources it with the
command the author wrote, so a command runs in the pipeline exactly as a developer types it after `.\importer.ps1` locally.

## Behaviour

- **Imports first** — it dot-sources the root `importer.ps1`, so every function is available without module qualification, and the command
  runs in that same scope.
- **Traps errors** — an error is written with `Write-Exception` and stops the step.
- **Sanitizes the command** — `ConvertFrom-AdoPipelineCommand` removes the YAML and ADO escaping artifacts from the command string.
- **Logs in coloured blocks** — the label (with the mode and the service connection when set), the environment diagnostic, the sanitized
  command and the command's own output, each between a header and a footer. With `SYSTEM_DEBUG` set to `true` it also turns verbose output
  on and writes the full environment diagnostic.

## help

### synopsis

Universal pipeline entry point. Bootstraps the module system and executes a command.

### description

Called by the invoke-automation.yaml step template. Imports all modules via importer.ps1, sanitizes the command string (YAML/ADO escaping
artifacts), sets up the error trap, then executes the command.

The command runs in the same scope as the importer — all functions are available without module qualification.

### parameter `Command`

The PowerShell command string to execute. This should be the same command a developer would type after running .\importer.ps1 locally.
Supports multiline commands (use YAML pipe operator in the template).

### parameter `Mode`

A label for the pipeline step's log line; none prints the plain Invoke-Automation label.

### parameter `ExposeAccessToken`

Reports in the log that the step exposes the pipeline access token to the command.

### parameter `ServiceConnection`

The name of the service connection the step runs under, reported in the log.

### parameter `AllowWarnings`

Passed to the importer, which then does not fail the import on a warning.
