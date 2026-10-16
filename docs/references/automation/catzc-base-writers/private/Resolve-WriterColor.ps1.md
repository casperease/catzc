---
catzc:
  immutable:
    with_body_sha: "4426264fdb44"
    repo_status: locked
    path: docs/references/automation/catzc-base-writers/private/Resolve-WriterColor.ps1.md
    folder: docs/references/automation/catzc-base-writers/private
    name: resolve-writer-color-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Writers/private/Resolve-WriterColor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($ForegroundColor -is [string]) {`, written with `#`.

```text
A 'rainbow' / '<base>-rainbow' bareword resolves to a gradient profile (the ToString round-trip); any
other string falls through to the plain ConsoleColor cast below.
```
