---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepDeploymentContext.Tests.ps1.md
    kind: test-asset
    body_sha: ec537ce47c65
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#26
      - ADR-AUTO-TEST#4
      - ADR-PWSH-PESTER#3
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The config/template boundary is mocked ONCE for the whole block and the config cache reset ONCE: every
test reads the same fixture config, and Get-Config keys its cache on the resolved (fixture) path, so the
first call derives it cold (~80ms) and the rest hit the warm cache. A per-test configCache reset would
force that cold re-derive on every test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)). Per-test we only wipe the (cheap) build folder,
which a couple of tests depend on being clean.
```

## comment:2

Above `$script:outputRoot = Join-Path (Get-RepositoryRoot)...`.

```text
Own output root through the seam: any other file building the 'sample' fixture from a sibling
worker can race the shared out/template/sample
([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26) — remove the sharing). Kept
under the repo because the repo-relative artifact contract is asserted below.
```

## comment:3

Above `Mock Build-Bicep {`.

```text
Mock Build-Bicep to materialize stub artifacts without invoking az ([System.IO], not the file cmdlets:
~0.1ms vs ~20ms/call — [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:4

Above `Mock Get-AzCliSessionSubscription {`.

```text
The deploy target is the az session's subscription — the whole-boundary session mock stands in
for the service connection / az account set
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)).
```

## comment:5

Above `Get-Config -Config azure | Out-Null`.

```text
Warm the fixture config + template-discovery caches ONCE, under the mocks above, so the cold derive
is paid here and not by whichever test happens to run first
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```

## comment:6

Above `BeforeAll {`.

```text
Boundary mocked + config cache reset ONCE (see the devbox block's note); per-test only the build folder
is wiped.
```

## comment:7

Above `BeforeAll {`.

```text
Boundary mocked + config cache reset ONCE (see the devbox block's note). None of these tests mutate the
artifacts folder or the env vars, so the fixture folder and the pipeline-env stand-ins are set up once and
torn down once.
```

## comment:8

Above `BeforeAll {`.

```text
Boundary mocked + config cache reset ONCE (see the devbox block's note); per-test only the build folder
is wiped (one test builds into it).
```

## comment:9

Above `Mock Get-BicepTemplate {`.

```text
Stand in for a template whose options.yml declared deployment_mode: DoNotRun, but keep
the rest of the real 'sample' descriptor so full resolution (when overridden) still works.
```
