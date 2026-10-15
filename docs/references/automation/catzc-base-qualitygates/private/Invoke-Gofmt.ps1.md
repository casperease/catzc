---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md
    kind: comment-page
    body_sha: eaf9157f8c08
    adrs:
      - ADR-PRIN-CONFIG#2
---

# automation/Catzc.Base.QualityGates/private/Invoke-Gofmt.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
gofmt is the gofmt beside the managed go at the tools.yml pin
([ADR-AUTO-GO](/docs/adr/automation/go/go-test-artifacts.md)), never whichever gofmt is first on PATH; a missing or
off-pin go throws, naming Install-Go. `gofmt -l` names the files that differ; without -DryRun, `gofmt -w`
rewrites exactly those. go.mod and go.work are not Go files: New-GoWorkspace and go itself write them.
```
