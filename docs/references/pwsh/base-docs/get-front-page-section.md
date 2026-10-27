# pwsh/Base.Docs/Get-FrontPageSection.ps1

Renders the front page's sections, one record each, in the order `frontpage.yml` declares them: a fragment from its article, a records
table from the decision records it names, or the contents list of every other section.

## help

### synopsis

Returns the front page's sections as rendered markdown, or the one section an id names.

### description

Reads every fragment's title first, since the contents list names them, then renders each section by its kind: `fragment` takes its
article's body (Get-FrontPageFragment), `records` the table of its records (Format-FrontPageRecords), and `contents` a link to every other
section by its GitHub anchor. An id that frontpage.yml does not declare throws.

### parameter `Id`

The one section to return. Default: every section.

### parameter `Config`

The front-page config. Default: `Get-Config -Config frontpage`.

### outputs

`[pscustomobject]` @{ Id; Title; Anchor; Markdown } per section, in declaration order.

### example 1

```powershell
Get-FrontPageSection | Select-Object Id, Title
```
