# pwsh/Azure.DevOps/Update-AdoFlowOccupants.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$block = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
The occupants are an input of the declaration, never a row
([TDR-STORES-FACTSOURCEREADONLY](/docs/drs/thesis/truth-stores.md#rule-tdr-stores-factsourcereadonly)): the old
map goes, the read one takes its place.
```
