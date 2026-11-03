# pwsh/Base.QualityGates/private/Get-PresentLanguageName.ps1

Names the registry languages a tracked file of the working root resolves to.

## help

### synopsis

Lists the names of the languages that at least one tracked file of the working root resolves to.

### description

Probes one tracked file per distinct name suffix with `Get-FileLanguage -Path`, so the cost follows the number of suffixes, not the number
of files. Get-QualityGateCheckSet reads it to keep only the checks of the languages the root actually holds.

### outputs

`[string[]]` the language names, each once, in the order the tracked files first resolve to them. Empty when nothing is tracked or no file
resolves to a language.
