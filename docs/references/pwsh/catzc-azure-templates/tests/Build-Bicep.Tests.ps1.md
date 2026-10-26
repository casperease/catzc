# pwsh/Azure.Templates/tests/Build-Bicep.Tests.ps1

<!-- cspell:ignore alweutstsmplst -->

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

Above `$script:outputRoot = Join-Path (Get-RepositoryRoot)...`, written with `#`.

```text
Own output root through the seam: any other file building the 'sample' fixture from a sibling
worker can race the shared out/template/sample
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](/docs/drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool) — remove the sharing).
```

## comment:3

Above `Get-BicepTemplates | Out-Null`, written with `#`.

```text
Warm the discovery and config caches once, here — the cold re-derive the reset above forces is
one-time setup cost, not the first test's duration
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce); it kept tipping that test
just
over the L0 limit).
```

## comment:4

Above `Mock Assert-AzCliBicep { throw 'Bicep CLI not available. Run az bicep...`, written with `#`.

```text
The Bicep CLI guard (Assert-AzCliBicep, in Catzc.Azure.Cli) throws -> Build-Bicep stops before any
az bicep build runs. Mock the guard boundary (its own az-version behaviour is covered in Cli tests).
```

## comment:5

Above `$script:outputRoot = Join-Path (Get-RepositoryRoot)...` (occurrence 2), written with `#`.

```text
Own output root through the seam (see the mocked-az block's note) — same isolated root as that
block: one file runs in one worker, so its blocks never overlap each other.
```
