# pwsh/Base.Variants/Test-TrackDeclaration.ps1

The consistency check across the track declarations: the tracks, the track types, the vendors and the module types are declared in separate
places, and this is where they are read together.

## help

### synopsis

Checks that the tracks, the track types, the vendors and the module types agree with one another.

### description

The `tracks` map ([DDR-TRACKTYPE-DECLAREDONCE](../../../drs/design/track-types.md#rule-ddr-tracktype-declaredonce)) and the track-types
registry are read apart, so this check reads them together: every track names a declared track type, every vendor a track names is declared,
and every place of every module type lies in a track whose track type admits that module type
([DDR-MODTYPE-TRACKTYPEADMITSMODULETYPES](../../../drs/design/module-types.md#rule-ddr-modtype-tracktypeadmitsmoduletypes)). A module place
that lies in no track is left out, since a root no git file is tracked under names no track. Throws one error naming every violation;
returns nothing when the declarations agree.

### example 1

```powershell
Test-TrackDeclaration
```

## Track names

A track's name is its definitive name in the repository normal form
([DDR-TRACKTYPE-NAMEFROMMEMBERS](../../../drs/design/track-types.md#rule-ddr-tracktype-namefrommembers)). The form is declared once, in the
languages config, and this check is where it is applied, so the VariantsConfig type holds no naming policy.
