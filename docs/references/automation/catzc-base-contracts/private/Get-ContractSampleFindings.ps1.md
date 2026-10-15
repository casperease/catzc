---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractSampleFindings.ps1.md
    kind: comment-page
    body_sha: "39413d2b3625"
    adrs:
      - ADR-REPO-CONTRACT#6
    links: []
---

# automation/Catzc.Base.Contracts/private/Get-ContractSampleFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The sample check of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6).
A sample payload `<name>.sample.<ext>` must be JSON or YAML by its extension and parse. When `<name>.schema.json`
sits in the same folder, with exactly that case (the rule Get-Contract uses to aim that schema at the sample), the
sample also validates against it (Get-ContractSchemaFindings). That the owning module produces or parses the sample
is the module's own tests' work, not this check's.
```
