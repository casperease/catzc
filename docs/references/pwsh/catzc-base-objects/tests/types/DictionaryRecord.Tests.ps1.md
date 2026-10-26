# pwsh/Base.Objects/tests/types/DictionaryRecord.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'DictionaryRecord'`, written with `#`.

```text
DictionaryRecord — the shared base of the YAML-mirror records: a dictionary view over a derived record's own
data properties, and the protected extraction helpers (Req / OptStr / StrArr / Flag) a derived constructor uses.
Exercised through a probe record compiled by Add-Type against the loaded combined assembly, which also shows a
type compiled later can derive from the base. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Add-Type -ReferencedAssemblies $assembly -TypeDefinition @'`, written with `#`.

```text
Gadget is never assigned by the first constructor -> genuinely null. (Passing $null from PowerShell
would coerce to '', the [string] $null->'' pitfall, so that constructor leaves it unset.)
```
