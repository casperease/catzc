# pwsh/Base.Slides/private/Get-SlidesKit.ps1

The loader of the slides kit: it reads the kit's defaults and every pattern from the kit folder.

## help

### synopsis

Loads the slides kit, its defaults and every pattern, from the kit folder.

### description

Reads `<kit>/slides.yml` into a SlidesKit and each `<kit>/patterns/<name>.html` into a SlidePattern, so a render or a check reads the kit
once (ADR-REPO-SLIDES-PATTERN). A kit folder, a defaults file or a patterns folder that does not exist fails at once.

### parameter `Kit`

The kit folder, repository-relative, such as python/diagrams/assets/slides.

### parameter `RepositoryRoot`

The repository root the kit folder is under.

### outputs

`[pscustomobject]` @{ Kit; Folder; Config (`[Catzc.Base.Slides.SlidesKit]`); Patterns (name to `[Catzc.Base.Slides.SlidePattern]`) }.
