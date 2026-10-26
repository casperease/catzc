# pwsh/Base.Variants/Get-AspectDeclaration.ps1

The reader of the aspect conventions in the variants config: for each track that declares aspects, the ordered aspect names and their
patterns, which `Get-Aspect` and `Get-AspectGlobSet` resolve against.

## help

### synopsis

Returns the aspect conventions the variants config holds, keyed by track.

### description

The `aspects` repo-wide variant, read through the private Get-Variant: each track's ordered aspect list, declared in variants.yml or built
in (VariantsConfig.DefaultAspects). Get-Aspect and Test-AspectDeclaration read the variant through this accessor, so the variants file keeps
one read path ([ADR-REPO-VARIANT](../../../drs/repository/repo-variants.md)).

### example 1

```powershell
(Get-AspectDeclaration)['infrastructure'].Name
```
