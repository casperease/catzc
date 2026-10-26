# pwsh/Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1

The tests of `Get-RootConfigRenderedFile` over a mocked generator dispatch.

## What they pin

A single-file generator's string and a multi-file generator's `{ Target; Content }` records normalise to the same records, and every shape
that would write a file the entry does not name throws. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
