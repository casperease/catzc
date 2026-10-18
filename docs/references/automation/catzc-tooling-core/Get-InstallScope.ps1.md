# automation/Catzc.Tooling.Core/Get-InstallScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the install scope of a tool based on its binary location.

### description

Determines whether a tool is installed in user-space or machine-wide
by inspecting the binary path. Returns 'user', 'machine', or 'unknown'.

### parameter Config

Tool configuration hashtable from Get-ToolConfig / tools.yml.

### parameter Location

Full path to the tool binary (from Get-Command .Source).
