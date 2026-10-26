# pwsh/Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1

The L0 tests of the YAML file scan, including the integrity checks that run it over the real repository.

## One assertion per set

The integrity checks make one `Should` over the violating set. A `Should` per discovered file would cost Pester's per-assertion price times
the whole repository's YAML count. The set is a `foreach` projection, not member enumeration, because `.RelativePath` on the empty set of a
passing run throws under strict mode.

## The `.git` check

The check that `.git` is excluded by default carries its own `integrity` tag, which keeps it a distinct, named check in the manual test
plan, a facet worth citing on its own. It still reuses the one scan above instead of walking the repository again
([ADR-AUTO-TEST-ONEIMPORTPERCASE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneimportpercase)).
