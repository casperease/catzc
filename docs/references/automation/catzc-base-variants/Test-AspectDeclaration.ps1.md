# automation/Catzc.Base.Variants/Test-AspectDeclaration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether the variants config holds aspects for one track.

### description

The guard over the `aspects` variant: $true when the variants config holds an aspect list for the track, declared in variants.yml or built
in (VariantsConfig.DefaultAspects). A caller that needs only the yes or no asks this instead of reading the config, so the variants file
keeps one read path ([ADR-REPO-VARIANT](../../../adr/repository/repo-variants.md)).

### parameter Track

The track name to test.

### example 1

```powershell
if (Test-AspectDeclaration infrastructure) { Get-Aspect -Track infrastructure }
```
