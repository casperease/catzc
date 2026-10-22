# pwsh/Catzc.Base.Slides/private/Get-DiagramCarrierMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads where each diagram's declaration lives: the draw.io kit's default carrier and the carriers it sets by stem.

### description

The kit's `configs/drawio.yml` declares `renderer.carrier`, the carrier of every diagram, and an optional `carriers:` map that sets another
carrier for a stem. A carrier is `file`, the diagram's own `<name>.drawio.yml`, or the article carrier, a `yml drawio` block in a page
beside the diagram's .assets. Throws when the kit has no drawio.yml or it declares no `renderer.carrier`.

### parameter `RepositoryRoot`

The repository root the kit folder is under.

### parameter `Kit`

The draw.io kit's folder, repository-relative. Default: `drawio_kit` of the slides config.

### outputs

`[pscustomobject]` Default, the carrier of every diagram, and Carriers, the carrier by stem.

### example 1

```powershell
(Get-DiagramCarrierMap -RepositoryRoot (Get-RepositoryRoot)).Default
```
