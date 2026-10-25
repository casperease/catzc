# pwsh/Catzc.Tooling.Toolchain/tests/Install-Shellcheck.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Install-Shellcheck'`, written with `#`.

```text
Install-Shellcheck and Uninstall-Shellcheck with the generic engine mocked: on Windows and macOS both delegate to the
tools.yml `shellcheck` entry (winget user scope, brew). The Linux apt path needs root and a Linux host, so it is not
exercised here.
```
