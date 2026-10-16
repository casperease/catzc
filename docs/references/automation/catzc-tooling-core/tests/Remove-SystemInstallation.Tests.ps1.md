---
catzc:
  immutable:
    with_body_sha: ed256fbd2099
    repo_status: locked
    path: docs/references/automation/catzc-tooling-core/tests/Remove-SystemInstallation.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-core/tests
    name: remove-system-installation-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#33
---

# automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Remove-SystemInstallation' -Tag 'L1', 'logic', 'ADR-AUTO-TEST#33' {`, written with `#`.

```text
Hermetic logic (L1): every boundary that touches state outside the repository is mocked — the install directory
delete (Remove-Item), the Machine PATH (Get-/Set-EnvironmentPath) and the Machine variables
(Set-PermanentEnvironmentVariable). The seams' real registry round trips are their own L3 system tests.
```
