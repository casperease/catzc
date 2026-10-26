# pwsh/Base.Contracts/private/Read-ContractData.ps1

The data reader of the contract checks: it reads a Json or Yaml file into one value, and throws when the file does not parse.

## help

### synopsis

Reads and parses a JSON or YAML file for a contract check, throwing a finding-ready message when it cannot.

### description

Parses by the format Get-ContractDataFormat names: Json with ConvertFrom-Json -AsHashtable, Yaml with the vendored ConvertFrom-Yaml
-Ordered, the first document only. The result is the value model ContractValue reads (objects as dictionaries, arrays as lists, scalars as
CLR values, an empty document as null), and an array is returned whole, never enumerated. A file of any other format, and a file that does
not parse, throw a message naming the file, which a contract check reports as its finding
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)).

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

## returning an array whole

The data goes out through `WriteObject` without enumeration, so a top-level array arrives as one object. `Write-Output -NoEnumerate` would
wrap the document in a list, since its input binds from the remaining arguments.
