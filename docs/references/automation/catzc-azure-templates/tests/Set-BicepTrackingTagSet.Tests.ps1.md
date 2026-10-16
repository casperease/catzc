---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Set-BicepTrackingTagSet.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a5656e5ab73b
    adrs:
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Azure.Templates/tests/Set-BicepTrackingTagSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-AzCliSessionSubscription {`, written with `#`.

```text
The scope subscription is the az session's — the whole-boundary session mock
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)).
```
