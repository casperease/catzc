---
catzc:
  immutable:
    with_body_sha: "75f2fa107539"
    path: docs/references/automation/catzc-tooling-toolchain/tests/Install-Shellcheck.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain/tests
    name: install-shellcheck-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Toolchain/tests/Install-Shellcheck.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Install-Shellcheck' -Tag 'L0', 'logic' {`, written with `#`.

```text
Install-Shellcheck and Uninstall-Shellcheck with the generic engine mocked: on Windows and macOS both delegate to the
tools.yml `shellcheck` entry (winget user scope, brew). The Linux apt path needs root and a Linux host, so it is not
exercised here.
```
