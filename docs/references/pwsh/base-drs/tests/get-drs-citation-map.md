# pwsh/Base.Drs/tests/Get-DrsCitationMap.Tests.ps1

The tests of `Get-DrsCitationMap`, which builds the citation registry the link engine derives every code link from
([ADR-REPO-LINK-CODELINKS](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-codelinks)).

## Fixtures

A fixture repository in `$TestDrive` carries a two-ADR index with neutral widget and gadget codes
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)), and
two code-less documents that share a file name, so the slug lookup's ambiguity is exercised too.
