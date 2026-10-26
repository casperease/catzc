# pwsh/Base.Docs/tests/Get-GlossarySources.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlossarySources'`, written with `#`.

```text
Get-GlossarySources is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)).
Discovery is redirected to the fixture sources under tests/assets/glossary/ through the Resolve-ConfigEntry seam,
so every source still loads through Get-Config and the GlossaryConfig type; git is mocked at Get-GitTrackedPath.
The fixture owners are loaded modules (Get-Config resolves validation in the owner's scope); the fixture terms
are neutral (widget/gadget, [ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter {...`, written with `#`.

```text
A mock defines only the parameters its caller passed, so -All / -Module are probed, not read bare (strict
mode).
```
