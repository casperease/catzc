---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d34b663abfc1
---

# automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$harnessModule = $MyInvocation.MyCommand.Module.Name`, written with `#`.

```text
The harness's own module rides in every build: workers reach its configuration builder and row reducer
through its module scope. Its tests still run only when the selection includes it.
The build names the resolved modules explicitly (closure-expanded again, so the harness's dependencies
come along).
```
