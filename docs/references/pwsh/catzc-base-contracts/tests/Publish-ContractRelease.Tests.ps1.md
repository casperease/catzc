# pwsh/Base.Contracts/tests/Publish-ContractRelease.Tests.ps1

Tests `Publish-ContractRelease`, which freezes a root's current version as a released version folder
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)): an exact copy
plus its `.frozen` record. It refuses a vendor root, a version below 1.0.0, the devbox build version, and a folder that exists. Fixtures are
a widget repository in `TestDrive:`
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); the
settings are mocked, so the logic tests read no shipped config.

The frozen copy is compared file for file with a whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)), so nothing is
pruned.
