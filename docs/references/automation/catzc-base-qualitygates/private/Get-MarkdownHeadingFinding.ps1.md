---
catzc:
  immutable:
    with_body_sha: "455a61eb1853"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-markdown-heading-finding-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$head = $Matches['head']`, written with `#`.

```text
Capture before the next -match overwrites $Matches
([ADR-PWSH-AUTOVAR](/docs/adr/pwsh/automatic-variable-pitfalls.md)).
```
