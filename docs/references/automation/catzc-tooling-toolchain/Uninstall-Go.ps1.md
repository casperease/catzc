# automation/Catzc.Tooling.Toolchain/Uninstall-Go.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls the Go toolchain installed by Install-Go.

### description

Removes the managed user-space home (Get-ScriptInstallDir: Windows %LOCALAPPDATA%\go, Unix ~/.go) and takes
its bin folder off the session and persistent PATH — the managed uninstall. Idempotent — skips when the home
does not exist. A Go installed elsewhere (a machine-wide MSI, a distro package) is not the managed install and
is left untouched. The module cache and build cache (GOPATH, GOCACHE) are Go's own data, not the install, and
are kept.

### example 1

```powershell
Uninstall-Go
```
