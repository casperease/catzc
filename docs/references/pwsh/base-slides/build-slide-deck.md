# pwsh/Base.Slides/Build-SlideDeck.ps1

The renderer of a slide deck: it reads a deck folder's slide files, renders each through its pattern from the slides kit and writes the
result and every fault found, without publishing.

## help

### synopsis

Renders a deck folder of slide files into the Slides artifact tree and a speaker script, fail-forward.

### description

Reads the deck file and every slide file of the deck folder, orders the slides by their head's order, renders each through its pattern from
the slides kit, and always writes the result to the output folder: project/deck.json, one `project/slides/<id>.html` per slide,
`<deck>.script.md` with the notes in order, and `<deck>.faults.md` with every fault found (ADR-REPO-SLIDES-FAILFORWARDRENDER). A missing
field, an unknown pattern, a gap or a duplicate in the orders, an over-capacity field, a code the index does not know and a quoted rule that
differs from the registry are each reported with the file and the field; nothing shrinks and nothing is guessed. It never publishes:
publishing the project tree to the artifact is a step a person takes after reading the render.

### parameter `Deck`

The deck folder, repository-relative, such as `docs/explanation/<area>/<deck>`.

### parameter `Kit`

The slides kit folder, repository-relative. The default is the slides config's kit.

### parameter `Theme`

The theme the deck renders in: the kit's `token` set for the default theme, its `token-<theme>` set for another, whose deck lands in
`<deck>-<theme>`. Default: `theme` of `slides.yml`, declared once on SlidesConfig.

### parameter `OutputFolder`

Where the render lands. The default is the kit's render.out followed by the deck folder's name.

### parameter `RepositoryRoot`

The repository root the deck and the kit are under.

### parameter `PassThru`

Return the result, with the faults, instead of only the files and the summary line.

### outputs

`[pscustomobject]` @{ Deck; Title; SlideCount; Faults (`[Catzc.Base.Slides.SlideFault[]]`); OutputFolder } with -PassThru.

### example 1

```powershell
Build-SlideDeck docs/explanation/<area>/<deck>
```

### example 2

```powershell
$result = Build-SlideDeck docs/explanation/<area>/<deck> -PassThru; $result.Faults
```

## Output folder

`OutputFolder` is filled in the body, not as a default: it is relative to `-RepositoryRoot`, declared after it, and to the kit config loaded
above.

## Images

An image the slide shows sits beside its slide file; it lands at the same relative path beside the slide's HTML.
