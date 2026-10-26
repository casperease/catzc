# pwsh/Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1

The L0 tests of `Resolve-InspirationRoot` over a `TestDrive` workspace with neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
`Get-RepositoryRoot` is the mocked boundary.

## Anchor

The `{workspace}` anchor resolves to the parent of the repository root
([ADR-AUTO-PATH-WORKSPACEANCHOR](../../../../drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)), and the result is a
normalized absolute path. The root is fed in both shells' views of the same folder, pwsh's and Git Bash's, so an anchor that resolved
differently per shell would fail here.
