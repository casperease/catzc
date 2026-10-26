# pwsh/Catzc.Base.QualityGates/Test-JavaScriptTypes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$projects = @('jsconfig.json') + @(if (@((Get-Config -Config...`, written with `#`.

```text
The generated jsconfig.json names the js track's files and the type roots Install-TypeScript fills (ADR-AUTO-JS-TYPESGATE); the
modules javascript.yml raises are checked once more, strictly, through jsconfig.strict.json, which it leaves them out of.
```
