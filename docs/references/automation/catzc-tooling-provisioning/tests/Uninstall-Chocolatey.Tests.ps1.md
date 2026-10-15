---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Chocolatey.Tests.ps1.md
    kind: test-asset
    body_sha: "8e251644476a"
    adrs:
      - ADR-AUTO-TEST#33
---

# automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
Hermetic: every boundary outside the repository is mocked — the admin check, the directory delete, the
persistent variable (Set-PermanentEnvironmentVariable) and the persistent PATH (Get-/Set-EnvironmentPath).
The seams' real registry round trips are their own L3 system tests
([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)).
```
