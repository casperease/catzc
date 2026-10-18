# automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerInputs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Every file besides the analyzed file itself that decides a PSScriptAnalyzer verdict.

### description

The analyzer's result cache keys each file on its SHA-256 and a stamp of these inputs
([ADR-AUTO-CACHE#10](../../../../adr/automation/caching.md#rule-adr-auto-cache10)), so this list must hold everything the analysis loads:
the settings file; every file of the custom rules (automation/.scriptanalyzer, the settings' CustomRulePath); the vendored analyzer's module
manifests, which name its version; and what the spelling rule's oracle reads — the English word list, the generated terminology dictionaries
(`.cspell/*.txt`) and the oracle's own source. A rule that starts reading another file adds it here in the same change.

### parameter RepositoryRoot

The repository root.

### parameter SettingsPath

The analyzer settings file.

### outputs

`[string[]]` Absolute paths, in a stable order.
