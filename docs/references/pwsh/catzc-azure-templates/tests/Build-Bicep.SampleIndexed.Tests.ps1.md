# pwsh/Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1

<!-- cspell:ignore weutstsidxst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Boundary mocks + config-cache reset run ONCE (the mocked config is identical every test); only the
build output folder is wiped per test, since the build tests write into it
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce)/[ADR-AUTO-TEST-SAFESEAMSWAPS](/docs/drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).
```

## comment:2

Above `Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates`, written with `#`.

```text
Devbox path: under CI the real Test-IsRunningInPipeline returns $true ($env:GITHUB_ACTIONS), and the
deployment-name test then hits Get-BicepDeploymentName's pipeline branch, which requires ADO-only
$env:BUILD_BUILDID and throws on GitHub Actions.
```

## comment:3

Above `Get-BicepTemplate sample-indexed | Out-Null`, written with `#`.

```text
Warm the discovery + config caches once, so the first It doesn't pay the cold Get-BicepTemplate
derive (template-tree enumeration + config load) inside its own timing
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce)). Every test
here reads the same fixture template, and BeforeEach wipes only the build output, not the caches.
```

## comment:4

Above `{ Get-BicepTemplateConfiguration sample-indexed alpha } | Should -Throw "*no...`, written with `#`.

```text
alpha with no -Slot resolves to config 'alpha', which this indexed-only template does not
configure (it has alpha-001 / alpha-002).
```
