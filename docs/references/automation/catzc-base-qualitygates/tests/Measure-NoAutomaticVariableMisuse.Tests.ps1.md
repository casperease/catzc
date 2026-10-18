# automation/Catzc.Base.QualityGates/tests/Measure-NoAutomaticVariableMisuse.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:emptySettings = @{ IncludeRules =...`, written with `#`.

```text
Empty settings prevents PSSA from auto-discovering PSScriptAnalyzerSettings.psd1
(which already lists this rule in CustomRulePath, causing double invocation).
```
