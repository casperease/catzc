# automation/Catzc.Tooling.Toolchain/Uninstall-Shellcheck.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls ShellCheck installed by Install-Shellcheck.

### description

Delegates to Uninstall-Tool, which removes the winget or brew package the tools.yml `shellcheck` entry names.

### parameter Version

The installed version to remove. Default: whatever is installed.

### example 1

```powershell
Uninstall-Shellcheck
```
