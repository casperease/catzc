---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Set-BicepTrackingTagSet.Tests.ps1.md
    kind: test-asset
    body_sha: b2e2ed0e12ad
    adrs:
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Azure.Templates/tests/Set-BicepTrackingTagSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-AzCliSessionSubscription {`.

```text
The scope subscription is the az session's — the whole-boundary session mock
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)).
```
