# automation/Catzc.Tooling.Provisioning/Uninstall-Git.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls Git installed by Install-Git.

### description

Windows: Removes LOCALAPPDATA\Git and cleans PATH.
macOS: brew uninstall git.
Linux: apt-get remove git (requires root).
Idempotent — skips if not installed.

### example 1

```powershell
Uninstall-Git
```
