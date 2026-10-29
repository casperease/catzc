# pwsh/Base.QualityGates/private/Get-SlideInputPath.ps1

A private helper of the generated-files drift check. It names the authored files a rendered slide or slide picture is made from, so a drift
on the render is traced to the input that moved.

## help

### synopsis

Names the repository paths of the inputs one slide render or slide picture is made from.

### description

For a `<name>.slide.png`, the inputs are the deck's `<name>.slide.md` and the picture its `## Image` section links; a slide with no page
names nothing. For any other file under a deck's `.assets` folder, the input is the one slide whose `## Image` links it, followed by the
`source:` the slide names and, for a `.drawio.png` source, its `.drawio.yml` declaration. A file no slide links names nothing. Every path is
repository-relative with forward slashes.

Private helper of the generated-files drift check; not exported.

### parameter `Path`

The repository-relative path of the rendered slide or picture.

### parameter `RepositoryRoot`

The repository root the paths resolve against. Default: the current repository.

### outputs

`[string]` One repository-relative path per input.

### example 1

```powershell
Get-SlideInputPath -Path docs/explanation/flow/widget-deck/.assets/gadget.slide.png
```
