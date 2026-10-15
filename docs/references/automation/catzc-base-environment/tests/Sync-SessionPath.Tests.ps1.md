---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/tests/Sync-SessionPath.Tests.ps1.md
    kind: test-asset
    body_sha: bac4a221ab1c
---

# automation/Catzc.Base.Environment/tests/Sync-SessionPath.Tests.ps1

<!-- cspell:ignore machinebin userbin -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:regUser = ''`.

```text
The persistent PATH is read through the Get-EnvironmentPath seam — mock it so these tests are
deterministic and never read the real machine registry. Each test sets $script:regUser/$regMachine.
```
