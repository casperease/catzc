---
catzc:
  immutable:
    with_body_sha: "8612777de18f"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestBlockTag.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-test-block-tag-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-TestBlockTag.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($levelTags in $levels) {`, written with `#`.

```text
The nearest level carrying any tag of this axis wins; return its canonical matches ('-eq' is
case-insensitive). One match is the norm; two means an ambiguous block, surfaced as a violation upstream.
```
