---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-AzureNamePatternSet.ps1.md
    kind: reference
    body_sha: b8100467e6c4
    adrs: []
---

# automation/Catzc.Azure.Templates/Get-AzureNamePatternSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every resource type (Get-AzureResourceTypeSet) ties to exactly one pattern via its `pattern`
property. A pattern is the recipe for turning the name components into a name — it fixes BOTH the
render separator AND the length budget (a restriction is length as much as format, not just the
missing hyphens):
  long    — hyphen-separated, generous: length does NOT bind, so the type carries its own `limit`
            (rg 90, waf 128, …). Most resources.
  kv      — hyphen-separated like `long`, but length-restricted to 24 (the key-vault class: a
            hyphenated name where 24 actually binds — customer+role can overflow it).
  storage — tight: segments concatenated (NO separator) → lowercase alphanumeric only, capped 24.
  vm      — the same tight (concatenated) render as `storage`, capped at 15 (Windows computer-name).

`kv`, `storage`, `vm` are the restricted archetypes — each carries an intrinsic binding `limit`,
and only `long` types may use a widened 5-char `type` abbreviation. `long` has no intrinsic limit,
so each long type supplies its own (generous, non-binding) Azure max.
```
