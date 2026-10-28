# pwsh/Base.QualityGates/Get-DrsUsage.ps1

The reader of who cites what in the decision records: it lists every DRS citation and DRS link the tracked files make, derived from the text
and never from a head, so the answer does not depend on a head being current.

## help

### synopsis

Lists every DRS citation and DRS link the tracked files make.

### description

Derives each file's citations and links from its text and its comment page with the processors the imprint uses, never from a head
([ADR-REPO-FILEMETA-NOREADBACK](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)), so a file with no head or a stale
one lists the same rows. One row per citation, in the order git lists the files. A code or rule the DRS index does not register, such as a
placeholder named in a comment, gives no row. A bare code is the whole record (Rule is null). A file whose carrier is a JSON property is not
listed, and neither is a file the index still lists but the working tree has deleted.

GroupBy Rule answers "who cites this rule": one row per code and rule, with the documents that cite it. GroupBy Document answers "what does
this file cite": one row per citing file, with its citations.

### parameter `RepositoryRoot`

The repository root. Defaults to the loaded repository root.

### parameter `Path`

Optional files or folders to limit the scan to.

### parameter `Code`

Keep only rows for these citation codes, such as ADR-PWSH-ERROR.

### parameter `Source`

Keep only rows from `cites` (cited in the file or its comment page) or from a `link` (linked from the file).

### parameter `GroupBy`

`Rule` for one row per cited rule, `Document` for one row per citing file. Default: the ungrouped rows.

### outputs

`[pscustomobject]` one @{ Path; Code; Rule; Source }, or with GroupBy Rule @{ Code; Rule; Count; Documents }, or with GroupBy Document @{
Path; Count; Citations }.

### example 1

```powershell
Get-DrsUsage -Code ADR-PWSH-ERROR -GroupBy Rule
```

### example 2

```powershell
Get-DrsUsage -Path docs/drs -Source link -GroupBy Document | Sort-Object Count -Descending
```
