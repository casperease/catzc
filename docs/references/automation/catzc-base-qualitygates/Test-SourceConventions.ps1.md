---
catzc:
  immutable:
    with_body_sha: "3bb9702f9f53"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/Test-SourceConventions.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: test-source-conventions-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$typesTestDirectory = Join-Path $testsDirectory 'types'`, written with `#`.

```text
tests/types/ holds the native-type tests, named for their type (which has no verb) — so each must name a
real types/*.cs of the module, and the folder cannot collect misplaced or misnamed tests.
```
