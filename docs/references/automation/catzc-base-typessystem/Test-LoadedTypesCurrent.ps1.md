---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Test-LoadedTypesCurrent.ps1.md
    kind: comment-page
    body_sha: c394e51995db
    adrs:
      - ADR-AUTO-TYPES#7
    links: []
---

# automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A loaded assembly cannot be unloaded or swapped in a running process: once a types/*.cs file changes after its
types loaded, this process keeps the old types until a new process loads the new ones
([ADR-AUTO-TYPES#7](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7)). This answers whether
that has happened, from the one measurement the loader and the importer use (Get-LoadedTypeDrift in
Catzc.Internal.Types): $true when every type the code root's sources declare is loaded as written (or none is
loaded yet), $false when a source was added, changed, or removed since the load, or the types were loaded on
behalf of another code root and differ. It throws on nothing; Assert-LoadedTypesCurrent is the throwing form.
```
