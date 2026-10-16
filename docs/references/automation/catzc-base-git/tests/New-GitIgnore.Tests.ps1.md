---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/tests/New-GitIgnore.Tests.ps1.md
    folder: docs/references/automation/catzc-base-git/tests
    name: new-git-ignore-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: faa62cb3951c
    adrs:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Base.Git/tests/New-GitIgnore.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.Git {`, written with `#`.

```text
Isolate through the config seam
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): a small
fixture registry with one static section (a
noted and a bare pattern) and one injected section.
```
