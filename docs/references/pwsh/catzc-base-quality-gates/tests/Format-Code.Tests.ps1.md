# pwsh/Base.QualityGates/tests/Format-Code.Tests.ps1

The tests of `Format-Code`, in six groups. Neutral fixture names are used throughout
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Seams

The main group mocks the seams
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)): the file-language registry
(`Get-Config languages`, a fixture `LanguagesConfig`), the scope (`Get-FormatScope`) and the engines (`Invoke-FormatterEngine`).

## Engine grouping and the result cache

One engine runs once per engine, and the content-keyed result cache is checked over real fixture files in `$TestDrive` with the engine
mocked ([ADR-AUTO-CACHE](../../../../drs/automation/caching.md)).

## Imprint steps

The steps after the engines: a global step over every language in scope, a language's own step over its files only, the merge into each
language's result, and the cache that never records a file a person must still repair.

## Engines

An integrity group: every engine the registry may name has its adapter, and the shipped `languages.yml` names only those engines
([PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE](../../../../drs/principles/configure-not-program.md#rule-pdr-config-newinstanceisconfigchange)). An
engine's settings entry may end in `#key`. The file must exist, and the stamp's own tests check the key.

## Real vendored analyzer

The real-asset test of
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest).
The psscriptanalyzer engine imports the vendored PSScriptAnalyzer (under the code root's `.vendor`) and formats with the shipped settings
file (under the code root's `.internal/assets`). Only the console is mocked. It is integrity, not source-only, so it runs in the source and
the build run. An explicit `-Path` over a throwaway file keeps it off the source tree.

## Real prettier

The prettier engine runs over throwaway files with only the console mocked. It skips itself when prettier is absent
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)).
