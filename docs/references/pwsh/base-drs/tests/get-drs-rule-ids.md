# pwsh/Base.Drs/tests/Get-DrsRuleIds.Tests.ps1

The tests of `Get-DrsRuleIds`.

## Fixtures

A fixture ADR tree holds an index beside two ADR files it lists, with paths relative to the index folder. A third ADR is not listed by the
index, so the tests can assert that only listed ADRs contribute.
