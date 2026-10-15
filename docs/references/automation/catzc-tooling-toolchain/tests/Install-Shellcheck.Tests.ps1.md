---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Install-Shellcheck.Tests.ps1.md
    kind: test-asset
    body_sha: "075691e21614"
---

# automation/Catzc.Tooling.Toolchain/tests/Install-Shellcheck.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Install-Shellcheck' -Tag 'L0', 'logic' {`.

```text
Install-Shellcheck and Uninstall-Shellcheck with the generic engine mocked: on Windows and macOS both delegate to the
tools.yml `shellcheck` entry (winget user scope, brew). The Linux apt path needs root and a Linux host, so it is not
exercised here.
```
