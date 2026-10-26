# pwsh/Base.Slides/private/Get-DiagramDeclarationText.ps1

The reader of a diagram's declaration: it returns the YAML text from whichever carrier the diagram has on disk, the yml file or the article
block.

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

## Both carriers

A diagram with both a yml and an article block is a finding the drift check reports, and it reads as the file.
