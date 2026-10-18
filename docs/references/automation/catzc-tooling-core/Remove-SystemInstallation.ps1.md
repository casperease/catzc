# automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes an installation directory and cleans it from system PATH.

### description

Shared helper for Remove-NodeJs, Remove-Python, etc. Deletes the directory, removes matching entries from the system (Machine) PATH, and
clears the specified Machine environment variables. Windows-only.

Every persistent write goes through its seam — Set-EnvironmentPath for the PATH, Set-PermanentEnvironmentVariable for a variable — which
announces the change; Windows broadcasts WM_SETTINGCHANGE on each persistent write, so running shells pick it up
([ADR-AUTO-TEST#33](../../../adr/automation/test-automation.md#rule-adr-auto-test33)).

### parameter InstallDir

Resolved absolute path to the installation directory.

### parameter ExtraPathDirs

Subdirectory names under InstallDir that are also on PATH (e.g. 'Scripts' for Python, 'wbin' for AzCli).

### parameter EnvironmentVariables

System-level environment variable names to clear.

### outputs

`[bool]` Whether the system PATH changed.
