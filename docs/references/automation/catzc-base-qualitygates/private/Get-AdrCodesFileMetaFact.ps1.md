# automation/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pattern = if ($withDomain) {`, written with `#`.

```text
Body text cites a rule as ADR-<CODE>#<n> only: a wildcard there is a mention of a family, never a citation. The group form is the
head's own notation, read back below from the held list.
```
