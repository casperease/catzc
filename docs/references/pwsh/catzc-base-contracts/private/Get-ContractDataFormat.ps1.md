# pwsh/Catzc.Base.Contracts/private/Get-ContractDataFormat.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Names the data format a contract check parses a file as, from its extension: Json, Yaml, or nothing.

### description

The one place the contract checks decide how a file is read
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): .json is Json; .yml
and .yaml are Yaml; any other extension is text, and gives nothing. A fragment of a Json or Yaml file is compared as a key subset, of any
other file as lines; a schema or a sample payload must be Json or Yaml. The extension compares ordinally.

### parameter `Path`

The file's path; only its extension is read.

### outputs

`[string]` Json or Yaml, or nothing for text.

### example 1

```powershell
Get-ContractDataFormat -Path '.widget/flows/build.yml'   # Yaml
```
