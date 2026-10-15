# docs/references/automation/catzc-base-contracts/private/Get-ContractAssetKind.ps1.md

`automation/Catzc.Base.Contracts/private/Get-ContractAssetKind.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The name rule of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6):
`<path>.schema.json` is a Schema, `<name>.sample.<ext>` is a Sample, and any other name is a Fragment, or a Presence
when the asset is empty (an empty fragment requires presence only). The schema suffix is checked first, so a
schema is never read as a sample.
```
