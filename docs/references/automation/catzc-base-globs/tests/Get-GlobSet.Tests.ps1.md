---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSet.Tests.ps1.md
    kind: test-asset
    body_sha: "1d03c901d42a"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{`.

```text
Neutral fixture globset names (widget/gadget), not the real loose-fileset/deployable-unit names, so
this logic test owns its inputs and editing the shipped globs.yml can never change its outcome
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
