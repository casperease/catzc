---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md
    kind: comment-page
    body_sha: "757bc9919dc4"
    adrs:
      - ADR-AUTO-TEST#33
---

# automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope Machine`.

```text
Remove environment variable
the seam announces each removal, and does nothing in a scope where the variable is not set
```

## comment:5

Above `foreach ($scope in 'Machine', 'User') {`.

```text
Remove Chocolatey from PATH — through the PATH seams, which announce the change
([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33))
```
