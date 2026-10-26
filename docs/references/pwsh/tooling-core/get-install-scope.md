# pwsh/Tooling.Core/Get-InstallScope.ps1

The classifier of where a tool is installed: it reads the binary's path and answers `user`, `machine` or `unknown`.

## help

### synopsis

Returns the install scope of a tool based on its binary location.

### description

Determines whether a tool is installed in user-space or machine-wide by inspecting the binary path. Returns 'user', 'machine', or 'unknown'.

### parameter `Config`

Tool configuration hashtable from Get-ToolConfig / tools.yml.

### parameter `Location`

Full path to the tool binary (from Get-Command .Source).
