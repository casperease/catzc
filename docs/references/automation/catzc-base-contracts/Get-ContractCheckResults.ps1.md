---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/Get-ContractCheckResults.ps1.md
    kind: comment-page
    body_sha: "6ca4af260a62"
    adrs:
      - ADR-PWSH-VERBS#2
      - ADR-PWSH-VERBS#6
      - ADR-REPO-CONTRACT#4
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/Get-ContractCheckResults.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Contracts are binding ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)): each asset
is checked by its kind ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)) and
gives one ContractCheckResult — Passed, and every finding as a precise message.
- Presence: the target file exists, with the exact case of its path, checked against the directory listing.
- Fragment: the target exists and contains the fragment. JSON and YAML compare as a key subset: every key path of the
  fragment exists in the target; a scalar equals the target's; each element of a fragment array is matched by at
  least one target element, in any order; a null pins its key only. Any other text: every non-blank fragment line
  appears in the target in order, not necessarily adjacent, trailing whitespace trimmed.
- Schema: the target exists and validates against the schema, YAML parsed first, by a bounded JSON Schema subset
  (type, required, properties, additionalProperties as a boolean, enum, items as one schema, const). The
  annotation keywords $schema, $id, $comment, title, description and examples are ignored by name and never
  constrain a value; any other keyword is a finding, never ignored. A schema whose target is the sample payload
  beside it is only checked to be well-formed in that subset: the sample's own check validates the sample, so a
  defect gives one finding, on one result.
- Sample: the payload parses as JSON or YAML by its extension, and validates against the `<name>.schema.json` beside
  it when one exists.

The assets come from the pipeline (Get-Contract) or -Asset; with neither, every asset of every unit's draft, 0.0.0,
is checked. A failed check is a result with Passed false, never an exception; only misuse throws (a null asset, a
repository root that does not exist). This returns records rather than a boolean, so it is a Get- and not a Test-
([ADR-PWSH-VERBS#2](/docs/adr/pwsh/respect-pwsh-verb-rules.md#rule-adr-pwsh-verbs2)), and the noun is
plural for the collection it returns
([ADR-PWSH-VERBS#6](/docs/adr/pwsh/respect-pwsh-verb-rules.md#rule-adr-pwsh-verbs6)).
```
