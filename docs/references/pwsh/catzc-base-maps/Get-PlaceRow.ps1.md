# pwsh/Base.Maps/Get-PlaceRow.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The place normal form of a repository path: the one minimised row the "Where does it live?" minimap prints for it.

### description

The path is normalised as a repository-relative path, its place is read the way the code-locations minimap reads it (track, module, folder),
and the row is the place in its minimised form: the module's prefix dropped whole and, past the row budget of the maps config, the middle of
the module elided at a segment boundary (ADR-AUTO-IDIOM-PLACENORMALFORM).

### parameter `Path`

The repository-relative paths to print the row of; a path outside every track prints nothing.

### outputs

`[string]` One row for each path inside a track.

### example 1

```powershell
Get-PlaceRow -Path pwsh/Azure.Templates/types/AzureTemplate.cs
```
