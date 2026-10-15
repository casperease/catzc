---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyConfig.ps1.md
    kind: reference
    body_sha: bbddd59d33d9
    adrs: []
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Loads the declared (allowed) module-to-module dependency graph via Get-Config, which
discovers configs/dependencies.yml, maps and validates it as a
Catzc.Base.ModuleSystem.DependenciesConfig, and caches it for the session. Re-run the importer
(.\importer.ps1) to clear the cache.

The returned object is a read-only ordered dictionary: module name -> list of names (modules or
groups) it is allowed to depend on. A module absent from this map is unconstrained (may depend on
anything). A malformed file throws here, at load time.
```
