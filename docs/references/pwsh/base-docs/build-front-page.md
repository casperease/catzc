# pwsh/Base.Docs/Build-FrontPage.ps1

The writer of the repository's front page: it composes the page from `frontpage.yml`, its title, tagline, badges, sections and closing, and
writes it with the generated-file head only when the content differs.

## help

### synopsis

Builds the front page from frontpage.yml and writes it when it changed.

### description

Composes the title, the tagline, the reference-style badges (each leading to a section by its id, or to a URL as given), every section of
Get-FrontPageSection, and the closing line, then wraps long lines, pads tables and adds the generated-file head. A front-page link that
names a decision record by its code throws, since the page speaks to a person in sentences.

### parameter `Config`

The front-page config. Default: `Get-Config -Config frontpage`.

### parameter `Path`

The page to write. Default: the config's `target`, resolved from the repository root.

### parameter `DryRun`

Report whether the page would change without writing it.

### parameter `Silent`

Write no message about the page written.

### parameter `PassThru`

Return a record ({ Path; Changed; DryRun; SectionCount }) instead of the page's path.

### outputs

`[string]` the page's repository-relative path; with -PassThru, `[pscustomobject]`.

### example 1

```powershell
Build-FrontPage -DryRun -PassThru
```
