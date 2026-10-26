# pwsh/Base.Drs/tests/Get-DrsDomainEdges.Tests.ps1

The tests of `Get-DrsDomainEdges` over a fixture `DrsConfig`, with `Get-Config` mocked.

## What it pins

The registry's own construction holds the edge invariants: declared ends, no self-edge, acyclic. So the tests pin only the projection. The
fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
