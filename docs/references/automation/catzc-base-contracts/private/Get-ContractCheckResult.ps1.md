---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractCheckResult.ps1.md
    kind: reference
    body_sha: "113ca48ab69c"
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/private/Get-ContractCheckResult.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs the check of the asset's kind ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)):
- Presence: the target exists with the exact case of its path (Get-ContractPresenceFindings);
- Fragment: the target exists and contains the fragment (Get-ContractFragmentFindings);
- Schema on a real file: the target exists and validates against the schema (Get-ContractSchemaFindings);
- Schema on a sample payload (its target is a sample under the asset's own module folder): the schema is well-formed
  and uses the supported keywords only; the sample is not validated here, since its own check does that, so a
  defect gives one finding on one result;
- Sample: the payload parses, and validates against the schema beside it (Get-ContractSampleFindings).
A failed check is findings on the result, never an exception.
```
