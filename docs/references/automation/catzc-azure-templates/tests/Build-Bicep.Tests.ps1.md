---
catzc:
  immutable:
    with_body_sha: f0827ce54949
    path: docs/references/automation/catzc-azure-templates/tests/Build-Bicep.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-templates/tests
    name: build-bicep-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{4,19,26}
---

# automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1

<!-- cspell:ignore alweutstsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Boundary mocks + config-cache reset run ONCE (the mocked config is identical every test); only the
build output folder is wiped per test, since the build tests write into it
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```

## comment:2

Above `$script:outputRoot = Join-Path (Get-RepositoryRoot)...`, written with `#`.

```text
Own output root through the seam: any other file building the 'sample' fixture from a sibling
worker can race the shared out/template/sample
([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26) — remove the sharing).
```

## comment:3

Above `Get-BicepTemplates | Out-Null`, written with `#`.

```text
Warm the discovery and config caches once, here — the cold re-derive the reset above forces is
one-time setup cost, not the first test's duration
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19); it kept tipping that test
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
