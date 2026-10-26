# pwsh/Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1

The tests of `InspirationRoot` over neutral fixture paths
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## Coverage

The `{workspace}` anchor resolves to the parent of the repository root
([ADR-AUTO-PATH-WORKSPACEANCHOR](../../../../../drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)), identically from
pwsh's and Git Bash's view of that root. The platform is a parameter, so every branch runs on every OS.
