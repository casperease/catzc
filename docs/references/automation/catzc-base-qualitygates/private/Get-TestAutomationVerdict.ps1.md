---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationVerdict.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-test-automation-verdict-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "36b69a7948bf"
    adrs:
      - ADR-AUTO-XPLAT#6
---

# automation/Catzc.Base.QualityGates/private/Get-TestAutomationVerdict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$seconds = [math]::Round($DurationSeconds,...`, written with `#`.

```text
Invariant so the duration reads the same on any devbox culture
([ADR-AUTO-XPLAT#6](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat6)) — a da-DK box would
otherwise render '42,3s' and diverge from CI's '42.3s'.
```
