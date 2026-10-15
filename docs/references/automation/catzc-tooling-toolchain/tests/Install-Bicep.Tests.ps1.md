---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Install-Bicep.Tests.ps1.md
    kind: test-asset
    body_sha: "7efadd1ede3d"
---

# automation/Catzc.Tooling.Toolchain/tests/Install-Bicep.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Install-Bicep' -Tag 'L0', 'logic' {`.

```text
Install-Bicep and Uninstall-Bicep with the generic engine mocked: on Windows and macOS both delegate to the tools.yml
`bicep` entry (winget user scope, brew). On Linux, Install-Bicep installs the verified release binary
(Install-BicepStandalone, tested on its own) and Uninstall-Bicep removes it from ~/.local/bin.
```
