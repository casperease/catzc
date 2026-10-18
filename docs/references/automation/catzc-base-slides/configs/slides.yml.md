---
catzc:
  immutable:
    with_body_sha: e792af520a32
    repo_status: locked
    path: docs/references/automation/catzc-base-slides/configs/slides.yml.md
    folder: docs/references/automation/catzc-base-slides/configs
    name: slides-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-SLIDES#6
---

# automation/Catzc.Base.Slides/configs/slides.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `kit: .claude/slides`, written with `#`.

```text
Where the slides kit lives, as a repository-relative folder (ADR-REPO-SLIDES#6). The kit's own defaults, its patterns and its style
guide are read from there; the default is declared once on SlidesConfig, so this file states only a deviation from it.
```
