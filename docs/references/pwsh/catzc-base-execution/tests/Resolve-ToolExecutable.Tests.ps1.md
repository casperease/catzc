# pwsh/Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The mapping from a tools.yml entry to the probe's plain inputs: the tools config is a fixture dictionary
(Get-Config mocked) and Find-Executable is mocked whole, so the assertions bind to which inputs each platform
and session actor hands it. Fixture tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `$script:tools = [Catzc.Base.Execution.ToolsConfig]::new([ordered]@{`, written with `#`.

```text
The typed registry the real Get-Config returns, so the function reads typed properties as it does in
production.
```
