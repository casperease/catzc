---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Read-ContractData.ps1.md
    kind: comment-page
    body_sha: "94c5d628eedd"
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/private/Read-ContractData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Parses by the format Get-ContractDataFormat names: Json with ConvertFrom-Json -AsHashtable, Yaml with the vendored
ConvertFrom-Yaml -Ordered, the first document only. The result is the value model ContractValue reads (objects as
dictionaries, arrays as lists, scalars as CLR values, an empty document as null), and an array is returned whole,
never enumerated. A file of any other format, and a file that does not parse, throw a message naming the file,
which a contract check reports as its finding
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)).
```

## comment:2

Above `$PSCmdlet.WriteObject($data, $false)`.

```text
WriteObject without enumeration hands a top-level array over whole; Write-Output -NoEnumerate would wrap the
document in a list, since its input binds from the remaining arguments.
```

## comment:3

Above `$PSCmdlet.WriteObject($data, $false)`.

```text
WriteObject without enumeration hands a top-level array over whole; Write-Output -NoEnumerate would wrap the
document in a list, since its input binds from the remaining arguments.
```
