---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyClosure.ps1.md
    kind: comment-page
    body_sha: "74c73797ce72"
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyClosure.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Breadth-first over the declared dependency map (Get-ModuleDependencyMap). The declared graph is a superset
of the real code edges (Test-ModuleDependency enforces actual ⊆ declared), so the closure is guaranteed
to contain every module the seeds need to load — copying it (Get-ModuleProfile → Copy-Automation) yields a
loadable subset. A group dependency was already expanded to its members when the map was built. Result is
ordinal-sorted for determinism. Seeds that are not on-disk modules contribute themselves but no edges.
```
