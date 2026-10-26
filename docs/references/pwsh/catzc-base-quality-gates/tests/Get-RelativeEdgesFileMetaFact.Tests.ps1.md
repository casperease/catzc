# pwsh/Base.QualityGates/tests/Get-RelativeEdgesFileMetaFact.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-PathModule { [pscustomobject]@{ name = (($Path -replace '\\',`, written with `#`.

```text
The fixture modules live under widgets/, which is no track of the shipped registry; the resolver's own
tests prove the real rule.
```

## comment:2

Above `$edges = Get-RelativeEdgesFileMetaFact -State ([pscustomobject]@{}) -Path...`, written with `#`.

```text
An edge no rule fills is an empty string, which the block leaves out; these cases look at the edges
that are there.
```
