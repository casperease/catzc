# pwsh/Base.Maps/Get-MinimapFact.ps1

The place lookup the minimap data commands share: for each subject path, its track, module and language, read once for a caller that draws
many minimaps.

## help

### synopsis

The place of each of a minimap subject's paths: its track, the module that holds it and its language.

### description

A caller that draws many minimaps in one run collects the subject paths of every diagram first and reads their places once. A place is read
from where the file sits, never from its head: the track (`Get-Track`, with its type and vendor), the module (`Get-PathModule`, with its
type) and the language (languages.yml). A fact a path has none of is empty, and a minimap places no file by an empty fact.

### parameter `Path`

The repository-relative paths of the subject files; repeats are read once.

### outputs

`[hashtable]`, path to its facts: track, tracktype, vendor, module, moduletype and language.

### example 1

```powershell
Get-MinimapFact -Path pwsh/Base.Maps/Get-WorldMap.ps1
```

## Where it sits

A file's place is read from where it sits in the tree, never from its head. The language comes from the extension and the languages config.
