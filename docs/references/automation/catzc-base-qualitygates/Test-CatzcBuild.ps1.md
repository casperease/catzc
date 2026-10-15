---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
    kind: comment-page
    body_sha: "334457a9ecae"
---

# automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$harnessModule = $MyInvocation.MyCommand.Module.Name`.

```text
The harness's own module rides in every build: workers reach its configuration builder and row reducer
through its module scope. Its tests still run only when the selection includes it.
The build names the resolved modules explicitly (closure-expanded again, so the harness's dependencies
come along).
```
