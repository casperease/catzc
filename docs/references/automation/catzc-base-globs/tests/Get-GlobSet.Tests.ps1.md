---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSet.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8b7411899738"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{`, written with `#`.

```text
Neutral fixture globset names (widget/gadget), not the real loose-fileset/deployable-unit names, so
this logic test owns its inputs and editing the shipped globs.yml can never change its outcome
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
