# docs/references/automation/catzc-base-contracts/private/Get-ContractDataFormat.ps1.md

`automation/Catzc.Base.Contracts/private/Get-ContractDataFormat.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place the contract checks decide how a file is read
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): .json is Json; .yml and .yaml
are Yaml; any other extension is text, and gives nothing. A fragment of a Json or Yaml file is compared as a key subset,
of any other file as lines; a schema or a sample payload must be Json or Yaml. The extension compares ordinally.
```
