# pwsh/Catzc.Base.Slides/private/Get-DiagramDeclarationText.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns a diagram's declaration text from its carrier, or nothing when the carrier holds none.

### description

The carrier is the one the carrier map sets for the stem, else its default. The `file` carrier is the diagram's own `<stem>.drawio.yml`. The
article carrier is the one `yml drawio` block, in a page of the folder that holds the diagram's .assets, that stands directly above the
image of its png; two or more such blocks return nothing, as does a missing file.

### parameter `Stem`

The diagram's stem, `.assets/<name>`, repository-relative.

### parameter `RepositoryRoot`

The repository root the stem is under.

### parameter `CarrierMap`

Where each diagram's declaration lives, as Get-DiagramCarrierMap reads it.

### outputs

`[string]` The declaration's YAML text; nothing when the carrier holds none.

### example 1

```powershell
Get-DiagramDeclarationText -Stem docs/drs/automation/.assets/widget -RepositoryRoot $root -CarrierMap (Get-DiagramCarrierMap -RepositoryRoot $root)
```
