# pwsh/Base.QualityGates/private/Get-GeneratedTrackedPath.ps1

A private helper of Test-GeneratedFiles. It names the generated files among the paths it is given, each with the writer and class of the
first writer-registry target that takes it, so the drift check walks the registry and never the heads.

## help

### synopsis

Names the generated files among the given paths, each with the writer and class of the registry target that takes it.

### description

A file is generated when a writer row's output takes it, read through Get-GeneratedTarget, the same answer the `generated` filter view
selects ([ADR-REPO-FILEMETA-PROVENANCEINHEAD](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-provenanceinhead)). No file is
opened, so a head on a path no output takes leaves the file authored as far as the check is concerned
([ADR-REPO-FILEMETA-NOREADBACK](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)). A path two targets take is
named once, by the first in registry order. No paths read no registry.

Private helper of Test-GeneratedFiles; not exported.

### parameter `Path`

The repository-relative paths to classify, such as every tracked path, or the tracked paths git reports changed.

### outputs

`[Catzc.Base.Variants.GeneratedTarget]` One per generated path: the path itself, its writer and the writer's class.

### example 1

```powershell
Get-GeneratedTrackedPath -Path @(Get-GitTrackedPath '.')
```
