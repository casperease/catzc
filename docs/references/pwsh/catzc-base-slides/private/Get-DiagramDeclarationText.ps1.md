# pwsh/Catzc.Base.Slides/private/Get-DiagramDeclarationText.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns a diagram's declaration text from its carrier, or nothing when the carrier holds none.

### description

The carrier is what is on disk. The `file` carrier is the diagram's own `<stem>.drawio.yml`, read when it exists. Otherwise the article
carrier is the one `yml drawio` block, in a page of the folder that holds the diagram's .assets, that stands directly above the image of its
png; two or more such blocks return nothing, as does a diagram with neither.

### parameter `Stem`

The diagram's stem, `.assets/<name>`, repository-relative.

### parameter `RepositoryRoot`

The repository root the stem is under.

### outputs

`[string]` The declaration's YAML text; nothing when the carrier holds none.

### example 1

```powershell
Get-DiagramDeclarationText -Stem docs/drs/automation/.assets/widget -RepositoryRoot $root
```

## comment:1

Above `$source = Join-Path $RepositoryRoot "$Stem.drawio.yml"`, written with `#`.

```text
The carrier is what is on disk: the yml beside the png (a diagram with both is a finding the drift check reports, and reads as the
file), else the article carrier.
```

## comment:2

Above `$name = $Stem.Substring($Stem.LastIndexOf('/') + 1)`, written with `#`.

```text
The article carrier: the one `yml drawio` block, in a page beside the diagram's .assets, directly above the image
of its png.
```
