# automation/Catzc.Base.Contracts/private/Read-ContractData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads and parses a JSON or YAML file for a contract check, throwing a finding-ready message when it cannot.

### description

Parses by the format Get-ContractDataFormat names: Json with ConvertFrom-Json -AsHashtable, Yaml with the vendored ConvertFrom-Yaml
-Ordered, the first document only. The result is the value model ContractValue reads (objects as dictionaries, arrays as lists, scalars as
CLR values, an empty document as null), and an array is returned whole, never enumerated. A file of any other format, and a file that does
not parse, throw a message naming the file, which a contract check reports as its finding
([ADR-REPO-CONTRACT#6](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract6)).

### parameter `RepositoryRoot`

The repository root the path is relative to.

### parameter `Path`

The file, repository-relative and '/'-separated.

### outputs

`[object]` The parsed document.

### example 1

```powershell
$gadget = Read-ContractData -RepositoryRoot $root -Path '.widget/gadget.yml'
```

## comment:1

Above `$PSCmdlet.WriteObject($data, $false)`, written with `#`.

```text
WriteObject without enumeration hands a top-level array over whole; Write-Output -NoEnumerate would wrap the
document in a list, since its input binds from the remaining arguments.
```
