# pwsh/Azure.Templates/Get-BicepCostEstimate.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$skus = @{}`, written with `#`.

```text
A type whose SKU a config decides reads it at its global address for the subscription; with no subscription to read for, it has none,
and its SKU-bound meters apply nowhere.
```
