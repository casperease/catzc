---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractAssetNote.ps1.md
    kind: comment-page
    body_sha: "1266a1e996ba"
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/private/Get-ContractAssetNote.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The note is what an asset says about itself, in the one place it can say it without changing what its check
compares ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)). Build-ContractReference
lists it per asset. By the asset's format (Get-ContractDataFormat):
- a YAML asset (a fragment or a sample payload): the leading run of '#' comment lines, which parsing ignores. The
  run ends at the first line that is not a comment, a blank line included;
- a schema: its top-level "$comment", the JSON Schema comment keyword, which the schema check accepts as a no-op.
  JSON has no comment syntax, so this is the one place a schema carries a note;
- every other asset carries none, and gives nothing: a presence asset is empty by definition; a text fragment's
  every non-blank line must appear in the real file, so a comment would bind the real file to it; and a JSON
  fragment or sample payload compares every key, so a note key would change what it pins.
The comment marks and the line breaks are dropped, so the note is one line with single spaces. An asset that does
not read or parse gives nothing: Test-Contracts reports it, and a note is never the place to fail.
```
