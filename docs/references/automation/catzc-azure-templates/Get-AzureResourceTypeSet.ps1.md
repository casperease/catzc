---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
    kind: comment-page
    body_sha: cfd70a4888e2
    adrs:
      - ADR-AZ-NAMING#4
---

# automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Each entry is keyed by its name abbreviation (the `<type>` segment of a resource name) and ties
to one of three render/constraint patterns (Get-AzureNamePatternSet):
  pattern — 'long' (hyphenated, generous), 'kv' (hyphenated but capped 24), 'storage'
            (tight/concatenated, capped 24), or 'vm' (tight like storage, capped 15). The pattern
            fixes the render separator AND the length budget — restriction is length as much as
            format. The restricted patterns (kv/storage/vm) carry an intrinsic binding cap.
  limit   — required only for `long`-pattern types (generous, per-type Azure max: rg 90, waf 128,
            sqldb 128, …); kv/storage/vm take their cap from the pattern.
  omit    — optional; component names this type drops from its render (e.g. `vm` drops
            org/customer/role to fit 15 — the resource group already encodes them). `type` is
            never omitted.

The `type` segment is 2-5 chars (see
[ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)); the widened 5-char form is only for
`long` types — the restricted `storage`/`vm` patterns keep a short 2-4 char abbreviation.

Starter set from [ADR-AZ-NAMING#4](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming4) — extend as the
consuming repos need.
```
