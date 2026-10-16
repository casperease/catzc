---
catzc:
  immutable:
    with_body_sha: fb1af72c9512
    repo_status: locked
    path: docs/references/automation/catzc-tooling-toolchain/tests/Install-Bicep.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain/tests
    name: install-bicep-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Toolchain/tests/Install-Bicep.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Install-Bicep' -Tag 'L0', 'logic' {`, written with `#`.

```text
Install-Bicep and Uninstall-Bicep with the generic engine mocked: on Windows and macOS both delegate to the tools.yml
`bicep` entry (winget user scope, brew). On Linux, Install-Bicep installs the verified release binary
(Install-BicepStandalone, tested on its own) and Uninstall-Bicep removes it from ~/.local/bin.
```
