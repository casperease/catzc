# pwsh/Base.QualityGates/private/Get-QualityGateCheckSet.ps1

Lists the quality gates the language registry names as checks, each once.

## help

### synopsis

Lists the union of the `checks:` of the languages a tracked file of the working root resolves to, each gate name once, in registry order.

### description

The one definition of the check set, shared by Test-QualityGates (which runs every gate) and Measure-QualityGates (whose `-Name` defaults to
it), so the two never hold a second copy of the union ([PDR-ONELIVE](../../../../drs/principles/one-living-version.md)). A language that
declares no checks adds nothing, and a language no tracked file resolves to (Get-PresentLanguageName) adds nothing. A check its language
scopes with `check_scopes` is kept only when the folder the scope's config address names exists.

### outputs

`[string[]]` the gate names, unique. Empty when no language declares a check.
