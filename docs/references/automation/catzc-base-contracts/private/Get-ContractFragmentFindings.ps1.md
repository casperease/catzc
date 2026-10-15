---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractFragmentFindings.ps1.md
    kind: reference
    body_sha: c60b5faa43e7
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/private/Get-ContractFragmentFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The fragment check of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6).
The target must first be present, with the exact case of its path (Get-ContractPresenceFindings); a missing target
is the only finding, since there is nothing to compare. Then, by the target's format (Get-ContractDataFormat):
- Json or Yaml: both files are parsed and compared as a key subset (ContractFragment.MatchData: every key path of
  the fragment exists in the target, a scalar equals, an array element is matched by some target element, a null
  pins the key only). A file that does not parse is the finding.
- any other text: every non-blank fragment line appears in the target in order, not necessarily adjacent, with
  trailing whitespace trimmed (ContractFragment.MatchLines).
```
