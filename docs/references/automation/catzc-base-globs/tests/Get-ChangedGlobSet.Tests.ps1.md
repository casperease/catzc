---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "86a7078e2057"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-FLOW-CD-GLOBS#1
---

# automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ChangedGlobSet' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-ChangedGlobSet: the computed area-of-control of a diff
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)) — the declared sets whose scan
program selects a changed path, reflected from git at real refs instead of from a committed marker hash.
```

## comment:2

Above `$script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{`, written with `#`.

```text
Neutral fixture globset names (widget/gadget/report), not the shipped set names, so this logic test
owns its inputs ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). 'report'
overlaps 'widget' on src/** (both loose-filesets, the
layer exempt from independence) to prove multi-set matches come back in registry order.
```
