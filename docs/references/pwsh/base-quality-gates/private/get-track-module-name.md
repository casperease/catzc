# pwsh/Base.QualityGates/private/Get-TrackModuleName.ps1

The mapping from a path in a language module to that module's full name on its track.

## help

### synopsis

Returns the full track name of the language module a path lies in, or nothing when it lies in none.

### description

Walks every modules track except the engine track and, for the first place the path lies under, takes the first folder below the place as
the module folder and returns the track's full name for it. The comparison ignores case. A path outside every place returns nothing.

### parameter `Path`

The path to place, absolute or relative to the working directory.

### outputs

`[string]` The module's full name on its track.

### example 1

```powershell
Get-TrackModuleName 'go/widget/main.go'
```
