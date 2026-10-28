# pwsh/Base.Maps/Use-WorldMapRevision.ps1

The scope that makes everything the world map reads come from one commit.

## help

### synopsis

Runs a script block with the configs and the decision records read from the given commit.

### description

Lists the commit's tree (Get-GitCommitTree) and loads, in one git process (Get-GitBlobText), every config file (`*.yml` under a `configs/`
folder) and every markdown file under the DRS root. It then runs the script block inside Use-RepositoryTextSource, named by the commit. In
that scope Get-Config, Get-DrsIndex, Get-DrsRules and Get-DrsCitationMap answer from the commit. So do the tracks, aspects, file languages,
module types and globsets they carry. A path only the working tree holds is absent. Get-WorldMap -Revision runs inside it, and the diagram
minimap data runs its facts and minimaps in the same scope, so one render reads one commit.

### parameter `Revision`

The full commit id. It names the scope, so a cached config of the commit never serves the working tree.

### parameter `ScriptBlock`

The work to run against the commit. Its output is returned.

### example 1

```powershell
Use-WorldMapRevision (Get-GitCurrentCommit) { Get-MinimapFact -Path 'importer.ps1' }
```
