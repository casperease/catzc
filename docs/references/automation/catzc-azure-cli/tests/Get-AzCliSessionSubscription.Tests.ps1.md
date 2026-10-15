---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/tests/Get-AzCliSessionSubscription.Tests.ps1.md
    kind: test-asset
    body_sha: "93975c5ef087"
    adrs:
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Azure.Cli/tests/Get-AzCliSessionSubscription.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The session read is a whole-function boundary mock
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)); config discovery
redirects to
the fixture identities, so nothing production is in play.
```
