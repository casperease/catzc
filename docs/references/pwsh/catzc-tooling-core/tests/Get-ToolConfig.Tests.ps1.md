# pwsh/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:configPath = (Get-Config -Config tools -ListOwners).Path`, written with `#`.

```text
Discovery-time: populates -ForEach data before tests run. tools.yml is located through its registered owner
(Catzc.Base.Execution owns it; this module reads it).
```

## comment:2

Above `$script:toolsFixture = [Catzc.Base.Execution.ToolsConfig]::new(@{ faketool = @{`, written with `#`.

```text
Hermetic fixture tool through the Get-Config seam, so the cache test never depends on the
shipped tools.yml ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). The
mock returns a STABLE typed ToolsConfig (Get-ToolConfig inherits its
same-reference caching from Get-Config's cached read), so both calls see one ToolConfig.
```
