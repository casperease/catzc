# automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads one tab-separated ADR map (a code map or a rule map) into one hashtable per row, keyed by the header.

### description

The map's first line must be exactly the expected header, and every row must have one cell per header column; anything else throws, naming
the file and line, before a single reference is rewritten ([ADR-AUTO-FAILFAST](../../../../adr/automation/fail-fast-with-asserts.md)). Blank
lines are skipped. The cells are validated by `[Catzc.Base.Docs.AdrCitationRewriter]`, which reads the rows.

### parameter Path

The absolute path of the map file.

### parameter Header

The expected column names, in order.

### outputs

`[hashtable[]]` One hashtable per data row, column name to cell.

### example 1

```powershell
Import-AdrCitationMapFile -Path $codeMapPath -Header 'old_code', 'new_code', 'old_path', 'new_path', 'kind'
```
