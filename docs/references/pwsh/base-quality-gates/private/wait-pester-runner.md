# pwsh/Base.QualityGates/private/Wait-PesterRunner.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `try {`, written with `#`.

```text
Short waits hand control back to PowerShell between polls, so a Ctrl-C or a PowerShell Stop() ends the call; one blocking wait
would hold the stop until every worker had finished.
```
