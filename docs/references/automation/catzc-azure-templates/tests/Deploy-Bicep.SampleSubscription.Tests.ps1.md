---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c6e445dd6f3f
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-AzCliSessionSubscription {`, written with `#`.

```text
The deploy target is the az session's subscription
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3) whole-boundary
mock).
```

## comment:2

Above `Get-Config -Config azure | Out-Null`, written with `#`.

```text
Warm the path-keyed session caches once, not per test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```

## comment:3

Above `Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates` (occurrence 2), written with `#`.

```text
Devbox path: without this the real Test-IsRunningInPipeline returns $true under CI
($env:GITHUB_ACTIONS) and Deploy-Bicep throws "requires -SubscriptionIdAssertIs in a pipeline".
```

## comment:4

Above `Get-Config -Config azure | Out-Null` (occurrence 2), written with `#`.

```text
Warm the path-keyed session caches once, not per test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```

## comment:5

Above `Get-Config -Config azure | Out-Null` (occurrence 3), written with `#`.

```text
Warm the path-keyed session caches once, not per test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```
