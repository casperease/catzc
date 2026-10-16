---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/tests/Get-AzCliSessionSubscription.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-cli/tests
    name: get-az-cli-session-subscription-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3a9fe16d66bb"
    adrs:
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Azure.Cli/tests/Get-AzCliSessionSubscription.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The session read is a whole-function boundary mock
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)); config discovery
redirects to
the fixture identities, so nothing production is in play.
```
