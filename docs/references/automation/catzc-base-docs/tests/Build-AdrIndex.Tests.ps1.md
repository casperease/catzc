---
catzc:
  immutable:
    with_body_sha: "2f44623e1bb4"
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/tests/Build-AdrIndex.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: build-adr-index-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Docs/tests/Build-AdrIndex.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$result = Test-GeneratedFiles -Generator Build-AdrIndex -PassThru...`, written with `#`.

```text
The importer's janitor tail materialised [index](/docs/adr/index.md) before this run; the gate checks it
without writing.
```
