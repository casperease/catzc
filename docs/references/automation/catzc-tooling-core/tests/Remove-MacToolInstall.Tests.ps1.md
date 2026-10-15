---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Remove-MacToolInstall.Tests.ps1.md
    kind: test-asset
    body_sha: b900445e5357
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:config = [pscustomobject]@{ command = 'widget'; pip_package =...`.

```text
A neutral fixture tool
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) — never a real tool identity.
```
