# pwsh/Catzc.Base.VSCode/tests/New-VSCodeExtensions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.VSCode {`, written with `#`.

```text
Isolate through the config seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/adr/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): a small
fixture registry.
```

## comment:2

Above `$engineExtension = @((Get-Config -Config languages).formatters.Values |...`, written with `#`.

```text
Get-Config constructs the VscodeExtensionsConfig type on load, so a render is also the shape proof. The
engines' extensions arrive as the root-config generator passes them.
```
