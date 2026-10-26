# pwsh/Base.QualityGates/tests/types/SpellingOracle.Tests.ps1

The test of the `SpellingOracle` type against its shipped dictionary. It is source-only: it loads the repository's committed dictionary and
the `.cspell/` lists, which are the inputs that only the source-tree analyzer rule `Measure-SpellOutIdentifiers` reads, and they give the
same answer in both run modes.

## Integrity

The test binds to the shipped English list and the generated term lists, so it is an integrity test by construction
([ADR-AUTO-TEST-ONECATEGORY](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)): it verifies the real oracle,
not a fixture. The static load is idempotent, so it is safe to run alongside any other consumer in the same process.

## Cases

`capi` is a fixture-category term, test-only vocabulary. It is coined in production scope and known only when fixtures are included, as in a
test file.

`zzq` is a 3-character nonsense token. It is not in the oracle (`IsKnown` is false), and it is below cspell's `minWordLength`, so
`Test-Spelling` does not flag the literal here.
