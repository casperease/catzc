# docs/references/automation/catzc-tooling-core/Get-ScriptInstallDir.ps1.md

`automation/Catzc.Tooling.Core/Get-ScriptInstallDir.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns the platform-appropriate install directory for a tool with script_install: true, and for a tool with an
msys2_url, whose Windows tree is the one its windows_install_dir names (zsh installs into Install-Git's Git for
Windows tree). Checks config overrides first, then falls back to sensible defaults per platform:
  Windows: LOCALAPPDATA\<windows_install_dir or command>
  Unix:    HOME/<unix_install_dir or .command>
```
