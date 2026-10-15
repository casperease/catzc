---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Deploy-Bicep.Tests.ps1.md
    kind: test-asset
    body_sha: "8c435c19439a"
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#4
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `[System.IO.Directory]::CreateDirectory($script:tempArtifacts) | Out-Null`.

```text
Static fixtures + boundary mocks set up ONCE (not per test). The only per-test state is the hook
marker files (pre-/post-called.json), cleared in BeforeEach; main.json/parameters/PrePost.psm1 never
change, so rebuilding them every test was pure filesystem-cmdlet tax (~5 cmdlet calls × ~20ms —
[ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)). [System.IO] writes them in
~0.1ms.
```

## comment:2

Above `$prepostContent = @'`.

```text
A real per-template PrePost.psm1 fixture. Under the current model there is NO default hook
loaded from assets — Deploy-Bicep runs only the hooks a template's own PrePost.psm1 exports.
These hooks record what they were called with to marker files, so the tests assert the
template's own hooks actually ran (and with the right context).
```

## comment:3

Above `InModuleScope Catzc.Base.Config { $script:configCache = $null }`.

```text
Reset $configCache ONCE (not per test): the mocked config is the same fixture azure.yml every test,
so a per-test clear only forced a needless cold re-parse (~65ms/test). Dropped once here so any
real-config entry from a prior test file is gone; the fixture config then stays warm.
```

## comment:4

Above `Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates`.

```text
These exercise the DEVBOX path; without this, the real Test-IsRunningInPipeline returns $true under
CI ($env:GITHUB_ACTIONS) and Deploy-Bicep throws "requires -SubscriptionIdAssertIs in a pipeline".
```

## comment:5

Above `Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter {...`.

```text
'customer' is mocked alongside azure/network so template discovery validates the sample-customer
fixture (its configuration/<customer>/ folders) against the fixture customer.yml, not the shipped one.
Without it this file is not hermetic — it passed only when Build-Bicep.SampleCustomer happened to
share a worker and pre-populate the template-descriptor cache
([ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)/[ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```

## comment:6

Above `Get-Config -Config azure | Out-Null`.

```text
Warm the fixture config + template-discovery caches ONCE, under the mocks above, so the cold derive
is paid here and not by whichever test happens to run first
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```

## comment:7

Above `foreach ($m in 'pre-called.json', 'post-called.json') {`.

```text
Clear ONLY the hook marker files so each test starts clean — the hooks write these, and several
tests assert a marker is absent (DryRun skips PostDeploy; DoNotRun runs no hooks).
```
