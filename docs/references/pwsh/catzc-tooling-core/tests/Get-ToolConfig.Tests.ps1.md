# pwsh/Tooling.Core/tests/Get-ToolConfig.Tests.ps1

The tests of `Get-ToolConfig` and of the shipped `tools.yml` as a set.

## Discovery

The `-ForEach` data is populated at discovery time, before the tests run. `tools.yml` is located through its registered owner:
Catzc.Base.Execution owns it, and this module reads it.

## Caching fixture

The cache test uses a hermetic fixture tool through the `Get-Config` seam, so it never depends on the shipped `tools.yml`
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). The
mock returns a stable typed `ToolsConfig`, since `Get-ToolConfig` inherits its same-reference caching from `Get-Config`'s cached read, so
both calls see one `ToolConfig`.

## Installable tools

OS-provided tools (winget) are asserted, never installed, so they have no Install and Uninstall functions. A tool another tool's installer
installs alongside itself (`installed_by`) has no pair of its own either.
