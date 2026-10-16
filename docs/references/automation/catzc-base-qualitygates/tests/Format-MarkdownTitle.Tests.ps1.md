---
catzc:
  immutable:
    with_body_sha: "79785be145fe"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Format-MarkdownTitle.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: format-markdown-title-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-MarkdownScope { , [string[]] @('docs/widget.md') } -ModuleName...`, written with `#`.

```text
Filter on the bound parameters, not on $Path: an unbound -Path resolves $Path from a caller's scope (the test
runner's own $Path), which would send the engine's whole-scope call to this narrowed mock too.
```
