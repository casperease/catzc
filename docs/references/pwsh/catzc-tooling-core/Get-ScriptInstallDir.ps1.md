# pwsh/Tooling.Core/Get-ScriptInstallDir.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the install directory for a script-installed tool, or the Windows tree an MSYS2 package installs into.

### description

Returns the platform-appropriate install directory for a tool with script_install: true, and for a tool with an msys2_url, whose Windows
tree is the one its windows_install_dir names (zsh installs into Install-Git's Git for Windows tree). Checks config overrides first, then
falls back to sensible defaults per platform:

```text
Windows: LOCALAPPDATA\<windows_install_dir or command>
Unix:    HOME/<unix_install_dir or .command>
```

### parameter `Config`

Tool configuration hashtable from Get-ToolConfig / tools.yml.
