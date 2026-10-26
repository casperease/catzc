# pwsh/Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1

The L0 tests of `Get-Inspiration` over a fixture config: `Get-Config` is mocked to the real `InspirationConfig` built from neutral widget
and gadget data
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Workspace

A `TestDrive` workspace holds widget and gadget but not gizmo, so an absent inspiration is proven reported and never thrown on
([ADR-REPO-INSPIRE-SIBLINGFORIDEAS](../../../../drs/repository/inspiration.md#rule-adr-repo-inspire-siblingforideas)).
