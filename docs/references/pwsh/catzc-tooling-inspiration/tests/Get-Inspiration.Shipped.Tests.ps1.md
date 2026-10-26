# pwsh/Tooling.Inspiration/tests/Get-Inspiration.Shipped.Tests.ps1

The test of `Get-Inspiration` over the shipped `inspiration.yml`, through the real `Get-Config` and the real repository root.

## Consistency, never presence

The test asserts consistency, never presence. On a machine without the sibling checkout the default inspiration is reported unavailable and
the test still passes ([ADR-REPO-INSPIRE-SIBLINGFORIDEAS](../../../../drs/repository/inspiration.md#rule-adr-repo-inspire-siblingforideas)).
