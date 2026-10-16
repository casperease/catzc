---
catzc:
  immutable:
    with_body_sha: f14f3cd7ba21
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: build-comment-view-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-OUTDIR#1
---

# automation/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Build-CommentView' -Tag 'L0', 'logic' {`, written with `#`.

```text
Build-CommentView writes the inverse of Export-Comments: the annotated copy of every file that has a comment page,
under the view folder in out/ ([ADR-REPO-OUTDIR#1](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir1)),
equal to the file before its comments moved
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). Tested in isolation on a
widget/gadget fixture repository in $TestDrive.
```
