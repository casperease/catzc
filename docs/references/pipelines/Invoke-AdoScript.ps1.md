# pipelines/Invoke-AdoScript.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
