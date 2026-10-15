---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-ModuleProfile.ps1.md
    kind: reference
    body_sha: "10321e27ef3a"
    adrs: []
---

# automation/Catzc.Base.ModuleSystem/Get-ModuleProfile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A profile (configs/profiles.yml) is a seed list of module names. This expands the seed to its transitive
declared-dependency closure (Get-ModuleDependencyClosure) so the result is loadable, then appends the fixed
infrastructure modules (.internal, .compiled, .vendor) unless -NoInfrastructure. An empty seed (the `full`
profile, or an empty -Modules) resolves to every on-disk named module.

The result is the module-name set to feed Copy-Automation -ModuleNames (Copy-Automation -ModuleProfile does
this for you) or Test-InIsolation.
```
