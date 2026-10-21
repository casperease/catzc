# pwsh/Catzc.Base.Maps/Get-MinimapFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The file facts of a minimap subject's paths, read in one Get-FileMetaFact call.

### description

A caller that draws many minimaps in one run collects the subject paths of every diagram first and reads their facts once, so the git
processes of the read are paid once per run rather than once per minimap. Each tracked path maps to its immutable facts; a path the read
skips (ignored, without a carrier, or not on disk) is absent and has no facts.

### parameter `Path`

The repository-relative paths of the subject files; repeats are read once.

### outputs

`[hashtable]`, path to its immutable facts.

### example 1

```powershell
Get-MinimapFact -Path pwsh/Catzc.Base.Maps/Get-WorldMap.ps1
```
