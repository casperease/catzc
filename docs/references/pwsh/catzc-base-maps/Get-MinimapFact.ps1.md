# pwsh/Catzc.Base.Maps/Get-MinimapFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
Get-MinimapFact -Path pwsh/Catzc.Base.Maps/Get-WorldMap.ps1
```
