# pwsh/Base.Drs/private/Import-DrsCitationMapFile.ps1

The private helper that reads a tab-separated code map or rule map into rows, failing before any reference is rewritten when the file is
malformed.

## help

### synopsis

Reads one tab-separated citation map (a code map or a rule map) into one hashtable per row, keyed by the header.

### description

The map's first line must be exactly the expected header, and every row must have one cell per header column; anything else throws, naming
the file and line, before a single reference is rewritten ([ADR-AUTO-FAILFAST](../../../../drs/automation/fail-fast-with-asserts.md)). Blank
lines are skipped. The cells are validated by `[Catzc.Base.Drs.DrsCitationRewriter]`, which reads the rows.

### parameter `Path`

The absolute path of the map file.

### parameter `Header`

The expected column names, in order.

### outputs

`[hashtable[]]` One hashtable per data row, column name to cell.

### example 1

```powershell
Import-DrsCitationMapFile -Path $codeMapPath -Header 'old_code', 'new_code', 'old_path', 'new_path', 'kind'
```
