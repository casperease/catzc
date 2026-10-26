# pwsh/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerInputs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Every file besides the analyzed file itself that decides one analyzer pass's PSScriptAnalyzer verdict.

### description

Each analyzer pass's result cache keys each file on its SHA-256 and a stamp of that pass's inputs
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)), so each
list must hold everything its pass loads. Both passes read the settings file and the vendored analyzer's module manifests, which name its
version. The `rules` pass reads every file of the custom rules (pwsh/.scriptanalyzer, the settings' CustomRulePath) but the spelling entry
rule's (CatzcSpelling.psm1, SpellOutIdentifiers.psm1). The `spelling` pass reads those two, and what the spelling rule's oracle reads — the
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

## comment:1

Above `foreach ($file in @(Get-ChildPath $folder -File -Filter $pattern -Depth 3...`, written with `#`.

```text
The rule files sit directly in .scriptanalyzer and the manifest one version folder into the vendored
module.
```
