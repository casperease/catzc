# pwsh/Base.Contracts/tests/Build-ContractReference.Tests.ps1

Tests `Build-ContractReference`, which writes one page per root, `docs/references/contracts/<root>.md`, listing each version folder's assets
with their notes ([ADR-REPO-CONTRACT-LAYOUT](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout)), as a committed
generated page ([ADR-REPO-README-AUTHOREDSOURCES](../../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)).
Fixtures are a widget repository in `TestDrive:`
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## The real reference

A second block checks the real contract reference against the real `contracts/` tree: the committed pages are what the writer would write
now. It reads only the repository's files.
