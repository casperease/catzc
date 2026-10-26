# pwsh/Base.Contracts/tests/Get-Contract.Tests.ps1

Tests `Get-Contract`, which lists `contracts/<root>/<version>/<group>/<path>` and derives every fact from the asset's name and place
([ADR-REPO-CONTRACT](../../../../drs/repository/api-contracts.md)): the target under the module's target root, the kind from the suffix, the
direction from the convention, and the addressing from the version's `contract.yml`. Fixtures are a widget repository in `TestDrive:`.
