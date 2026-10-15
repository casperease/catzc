---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-AzureNameOrderSet.ps1.md
    kind: comment-page
    body_sha: ac4c9379614e
---

# automation/Catzc.Azure.Templates/Get-AzureNameOrderSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Each order is an ordered list of *segments*; each segment is a list of component names that fuse
together (concatenated with no separator), and segments are joined by the render separator of the
type's pattern (hyphen for long/kv, nothing for storage/vm). Components: env, slot, region, org,
short_name, customer, role, type. `env` and `slot` are SEPARATE segments. Optional components
(slot, customer, role) are skipped when empty; an empty segment is dropped.

  standard — env then slot first, type last (the catzc default):
             <env>-<slot>-<region>-<org>-<short_name>[-<customer>][-<role>]-<type>
  classic  — type first (CAF-style), slot trailing:
             <type>-<org>-<short_name>[-<customer>]-<env>-<region>[-<slot>][-<role>]

The active order is selected by the `ado_naming` repo-wide variant — Get-AdoNaming (default `standard`),
a variants.yml setting fixed for the importer session. Orders are pure data — add or reorder one here
without touching the assembler.
```
