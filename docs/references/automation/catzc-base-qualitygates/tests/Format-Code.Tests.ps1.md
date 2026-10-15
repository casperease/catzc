---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Format-Code.Tests.ps1.md
    kind: test-asset
    body_sha: ad9ec2adce25
    adrs:
      - ADR-AUTO-ASSETDEP#3
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#6
      - ADR-AUTO-TEST#8
      - ADR-PRIN-CONFIG#2
      - ADR-REPO-FORMAT#8
---

# automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Format-Code' -Tag 'L0', 'logic' {`.

```text
Format-Code with its seams mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): the
file-language registry (Get-Config languages, a fixture LanguagesConfig), the scope (Get-FormatScope) and the engines
(Invoke-FormatterEngine). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Format-Code engine grouping and result cache' -Tag 'L0', 'logic' {`.

```text
One engine run per engine, and the content-keyed result cache, over real fixture files in $TestDrive with the engine
mocked ([ADR-AUTO-CACHE](/docs/adr/automation/caching.md)).
```

## comment:3

Above `Describe 'Format-Code imprint steps' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#8' {`.

```text
The imprint steps after the engines: a global step over every language in scope, a language's own over its files only, the merge
into each language's result, and the cache that never records a file a person must still repair.
```

## comment:4

Above `Describe 'Format-Code engines' -Tag 'L0', 'integrity' {`.

```text
Integrity: every engine the registry may name has its adapter, and the shipped languages.yml names only those engines
([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
```

## comment:5

Above `Describe 'Format-Code (real vendored analyzer and settings)' -Tag 'L2',...`.

```text
The real-asset test of [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3):
the psscriptanalyzer engine imports the vendored PSScriptAnalyzer (<code root>/.vendor) and formats with the shipped
settings file (<code root>/.internal/assets), nothing mocked but the console — integrity, and not source-only, so it
runs in the source and the build run. An explicit -Path over a throwaway file keeps it off the source tree.
```

## comment:6

Above `Describe 'Format-Code (real prettier)' -Tag 'L2', 'logic' {`.

```text
The prettier engine over throwaway files, nothing mocked but the console; self-skips when prettier is absent
([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)).
```
