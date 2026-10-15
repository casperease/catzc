# docs/references/automation/catzc-base-variants/private/Get-Variant.ps1.md

`automation/Catzc.Base.Variants/private/Get-Variant.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place variants.yml is read. Variants are fixed for the importer session (Get-Config caches the
parsed config per session; re-run the importer to pick up an edit — see
[ADR-AUTO-CACHE](/docs/adr/automation/caching.md)).
The typed primitives (Get-AdoNaming, Test-HaveCustomers, …) are thin wrappers over this reader so the
growing variant dictionary has a single access point. Private — callers use the named primitives.
```
