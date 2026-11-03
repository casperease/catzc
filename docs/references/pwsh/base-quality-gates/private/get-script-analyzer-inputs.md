# pwsh/Base.QualityGates/private/Get-ScriptAnalyzerInputs.ps1

Lists every file besides the analyzed file itself that decides one analyzer pass's PSScriptAnalyzer verdict. The result cache keys on them,
so a changed rule or manifest re-checks the files.

## help

### synopsis

Every file besides the analyzed file itself that decides one analyzer pass's PSScriptAnalyzer verdict.

### description

Each analyzer pass's result cache keys each file on its SHA-256 and a stamp of that pass's inputs
([ADR-AUTO-CACHE-CROSSSESSIONFILES](../../../../drs/automation/caching.md#rule-adr-auto-cache-crosssessionfiles)), so each list must hold
everything its pass loads. Both passes read the settings file and the vendored analyzer's module manifests, which name its version. The
`rules` pass reads every file of the custom rules (pwsh/.scriptanalyzer, the settings' CustomRulePath) but the spelling entry rule's
(SpellingEntryRule.psm1, SpellOutIdentifiers.psm1). The `spelling` pass reads those two, and what the spelling rule's oracle reads — the
English word list, the generated terminology dictionaries (`.cspell/*.txt`) and the oracle's own source. A rule that starts reading another
file adds it here in the same change.

### parameter `RepositoryRoot`

The repository root.

### parameter `SettingsPath`

The analyzer settings file.

### parameter `Pass`

The analyzer pass: `rules` (every rule but the spelling entry rule) or `spelling` (that rule alone).

### outputs

`[string[]]` Absolute paths, in a stable order.

## Where the inputs sit

The rule files sit directly in `.scriptanalyzer`. The manifest sits one version folder into the vendored module.

The rules, the vendored analyzer and the spelling oracle's own source and word list are read from the code root (Get-CatzcModulesRoot): the
repository's modules folder in source mode, the bundle in build mode, where the bundle carries them whenever its selection holds the gates
module ([ADR-AUTO-CONSUMER-CATZCGATES](../../../../drs/automation/consumer-repository.md)). The settings file is the caller's
`SettingsPath`, and the generated term lists (`.cspell/*.txt`) sit under the `RepositoryRoot` argument, the working root, so a consumer's
own terms and settings key its cache, never the bundle's.
