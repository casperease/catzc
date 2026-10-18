# automation/Catzc.Tooling.Toolchain/Install-Shellcheck.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs ShellCheck, the analyzer for the repository's shell scripts, at the tools.yml pin.

### description

ShellCheck is the analyzer the Test-ShellScripts quality gate runs over every tracked `*.sh` file
([ADR-AUTO-ENGINE](../../../adr/automation/execution-engines.md)). Windows and macOS delegate to Install-Tool: winget koalaman.shellcheck as
a user-scope portable (no admin), or brew. Linux installs the distribution's shellcheck package with apt-get, which needs root. Idempotent:
a ShellCheck already at the pinned version is left alone; another version throws unless -Force.

### parameter `Version`

The version prefix to install. Default: the tools.yml pin.

### parameter `Force`

Replace an installed ShellCheck at another version.

### example 1

```powershell
Install-Shellcheck
```
