# pwsh/Tooling.Toolchain/tests/Get-RegisteredInstallProduct.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:entries = @{`, written with `#`.

```text
Two uninstall-registry views: the bundle registers only in the 32-bit one, its MSI in the 64-bit one, under the
same display name — the shape the .NET runtime installers leave.
```
