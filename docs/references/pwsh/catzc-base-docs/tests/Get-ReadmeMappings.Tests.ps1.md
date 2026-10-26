# pwsh/Base.Docs/tests/Get-ReadmeMappings.Tests.ps1

The tests of `Get-ReadmeMappings`. The function is private, so it is exercised through the module (`InModuleScope`, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)).

## Fixture

The fixture repository holds `widgets/<modules>` and a dot-directory, with reference articles as the sources for two of the three modules. The
source-tree guard is its own unit, below; here it is mocked so the fixture stands in for the source tree in either run mode. The glob-shape
check throws before the repository root is ever read, so that test needs no root plumbing and a literal placeholder root is enough.
