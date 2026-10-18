# automation/Catzc.Base.Variants/Test-TrackDeclaration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks that the tracks, the track types, the vendors and the module types agree with one another.

### description

The `tracks` map ([ADR-DSGN-TRACKTYPE#4](../../../adr/design/track-types.md#rule-adr-dsgn-tracktype4)) and the track-types registry
are read apart, so this check reads them together: every track names a declared track type, every vendor a track names is
declared, and every place of every module type lies in a track whose track type admits that module type
([ADR-DSGN-MODTYPE#3](../../../adr/design/module-types.md#rule-adr-dsgn-modtype3)). A module place that lies in no track is left
out, since a root no git file is tracked under names no track. Throws one error naming every violation; returns nothing when
the declarations agree.

### example 1

```powershell
Test-TrackDeclaration
```
