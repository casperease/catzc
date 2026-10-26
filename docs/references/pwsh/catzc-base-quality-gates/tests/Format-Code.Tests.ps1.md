# pwsh/Base.QualityGates/tests/Format-Code.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Format-Code'`, written with `#`.

```text
Format-Code with its seams mocked ([ADR-AUTO-TEST-NOOVERMOCKING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)): the
file-language registry (Get-Config languages, a fixture LanguagesConfig), the scope (Get-FormatScope) and the engines
(Invoke-FormatterEngine). Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Format-Code engine grouping and result cache'`, written with `#`.

```text
One engine run per engine, and the content-keyed result cache, over real fixture files in $TestDrive with the engine
mocked ([ADR-AUTO-CACHE](/docs/drs/automation/caching.md)).
```

## comment:3

Above `Describe 'Format-Code imprint steps'`, written with `#`.

```text
The imprint steps after the engines: a global step over every language in scope, a language's own over its files only, the merge
into each language's result, and the cache that never records a file a person must still repair.
```

## comment:4

Above `Describe 'Format-Code engines'`, written with `#`.

```text
Integrity: every engine the registry may name has its adapter, and the shipped languages.yml names only those engines
([PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE](/docs/drs/principles/configure-not-program.md#rule-pdr-config-newinstanceisconfigchange)).
```

## comment:5

Above `Describe 'Format-Code (real vendored analyzer and settings)'`, written with `#`.

```text
The real-asset test of [ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest):
the psscriptanalyzer engine imports the vendored PSScriptAnalyzer (<code root>/.vendor) and formats with the shipped
settings file (<code root>/.internal/assets), nothing mocked but the console — integrity, and not source-only, so it
runs in the source and the build run. An explicit -Path over a throwaway file keeps it off the source tree.
```

## comment:6

Above `Describe 'Format-Code (real prettier)'`, written with `#`.

```text
The prettier engine over throwaway files, nothing mocked but the console; self-skips when prettier is absent
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)).
```

## comment:7

Above `Join-Path $root ($settingsFile -split '#', 2)[0] |`, written with `#`.

```text
An entry may end in #key: the file is what must exist here, the key is checked by the stamp's own
tests.
```
