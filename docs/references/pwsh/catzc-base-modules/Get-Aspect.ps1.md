# pwsh/Catzc.Base.Modules/Get-Aspect.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns a track/container's ordered aspect classification — the named parts its units partition into.

### description

An aspect convention is an ordered first-match (fallthrough) classification of VariantAspect { Name, Patterns }, patterns relative to the
unit root; the LAST aspect is the '`**`' catch-all remainder ([DDR-ASPECT](../../../adr/design/module-aspects.md)).

A code track (a track of the modules track type) derives its convention from the layout
([ADR-AUTO-MODULE-EXISTSBYLAYOUT](../../../adr/automation/module-model.md#rule-adr-auto-module-existsbylayout)): 'live' is the patterns of
the layout's live rows, kept closed so a stray file falls to the 'tests' catch-all and never ships. Any other track takes the convention its
`aspects` entry in configs/variants.yml declares, else the built-in one: 'infrastructure' (a deployment) makes 'live' the catch-all, so
everything under a template ships and only an explicit tests/ folder is non-live. A track with neither falls back to the code convention.
The `aspects` shape is validated by the VariantsConfig type; the Globs aspect engine compiles each aspect into a scan program.

### parameter `Track`

The track/container whose convention to return ('automation', 'infrastructure', …).

### example 1

```powershell
Get-Aspect -Track automation      # -> live (closed, from the layout), tests (catch-all)
```

### example 2

```powershell
(Get-Aspect -Track infrastructure)[-1].Name   # -> 'live' (a deployment's catch-all is live)
```
