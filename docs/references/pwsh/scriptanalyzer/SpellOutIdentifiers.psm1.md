# pwsh/.scriptanalyzer/SpellOutIdentifiers.psm1

The custom analyzer check `Measure-SpellOutIdentifiers`: identifier names are spelled out, with no invented local abbreviations.

## What it catches

It tokenizes every variable name with no length floor, so it catches short coined names that the spelling check lets pass. Every variable
reference counts: assignment targets, parameters, loop variables and reads. Each distinct coined name is reported once per file, not once
per occurrence, since a variable read ten times is one naming problem.

A variable on an external or special drive (`$env:`, `$function:`, `$variable:` …) is not an identifier the author chooses, so it is not
checked ([ADR-AUTO-SPELL-IDENTIFIERSNOTDATA](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-identifiersnotdata)). The
automatic, preference and well-known variables the language owns are skipped too; the set mirrors the one in `VariableCasing.psm1`.

## Fixture terms

Fixture terms (`.cspell/fixture.txt`) are test-only vocabulary
([ADR-AUTO-SPELL-CATEGORYANDMEANING](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)). They are kept
apart from the other terms, and the oracle accepts them only when the file under analysis is a test (`*.Tests.ps1` or under a `tests/`
folder, decided by `Test-AnalyzedFileIsTest`), never in production code.

## The oracle

The check consults the `SpellingOracle` type, which must be brought into the rule's own runspace and its dictionary loaded, once. This runs
at rule-invocation time, not at module load, for two reasons: PSScriptAnalyzer resolves and runs custom rules in its own runspace, whose
type-resolution table does not inherit assemblies the importer loaded in the parent, and the analyzer shards are bare pwsh processes with
neither the module system nor `$env:RepositoryRoot`. So the paths resolve from `$PSScriptRoot` (the file lives in `pwsh/.scriptanalyzer/`).

The initialiser is idempotent: a module-scope flag guards it, and the type load is skipped when the type already resolves.

The types assembly is the build for the current sources, keyed by the one shared hash (`Get-CombinedTypeHash`), never picked by file age.
It loads through the one shared load path (`Import-TypesAssembly`, a per-user shadow copy), so an editor host or analyzer shard never locks
a build inside `.compiled`. `Catzc.Internal.Types` has no importer dependencies, so it imports by path even in a bare analyzer process.

The quality-gates module folder is resolved from its full name under the modules track's namespace before any import
([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).

## Predicates

The predicates are locals, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
