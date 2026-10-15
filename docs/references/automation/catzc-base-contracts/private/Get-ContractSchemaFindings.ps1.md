---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractSchemaFindings.ps1.md
    kind: comment-page
    body_sha: "036053c04766"
    adrs:
      - ADR-REPO-CONTRACT#6
    links: []
---

# automation/Catzc.Base.Contracts/private/Get-ContractSchemaFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The schema check of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6),
shared by a schema asset and a sample payload with a schema beside it. Both files are parsed (Read-ContractData;
YAML is parsed before it is validated) and the value validates against the bounded JSON Schema subset of
ContractSchema, which ignores the annotation keywords and reports every other keyword outside the subset as
unsupported. A file that does not parse, or is neither JSON nor YAML, is the finding.
With no -InstancePath, only the schema is parsed and checked to be well-formed in the subset (ContractSchema.Inspect):
a schema aimed at a sample payload is checked that way, since the sample's own check validates the sample, and a
defect gives one finding, not two.
```
