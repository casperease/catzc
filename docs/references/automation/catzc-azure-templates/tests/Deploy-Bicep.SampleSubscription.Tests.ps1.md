---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1.md
    kind: test-asset
    body_sha: b30fa2b27c42
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-AzCliSessionSubscription {`.

```text
The deploy target is the az session's subscription
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3) whole-boundary
mock).
```

## comment:2

Above `Get-Config -Config azure | Out-Null`.

```text
Warm the path-keyed session caches once, not per test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```

## comment:3

Above `Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates`.

```text
Devbox path: without this the real Test-IsRunningInPipeline returns $true under CI
($env:GITHUB_ACTIONS) and Deploy-Bicep throws "requires -SubscriptionIdAssertIs in a pipeline".
```

## comment:4

Above `Get-Config -Config azure | Out-Null`.

```text
Warm the path-keyed session caches once, not per test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```

## comment:5

Above `Get-Config -Config azure | Out-Null`.

```text
Warm the path-keyed session caches once, not per test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```
