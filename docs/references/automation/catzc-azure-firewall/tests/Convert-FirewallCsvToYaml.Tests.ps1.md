---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/tests/Convert-FirewallCsvToYaml.Tests.ps1.md
    kind: test-asset
    body_sha: "9d05d52b94fc"
---

# automation/Catzc.Azure.Firewall/tests/Convert-FirewallCsvToYaml.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `(Get-Content $out -Raw) | Should -Match '# CSV generated: 2026-06-16 10:32 UTC'`.

```text
Literal ':' guards against the locale separator regression — the function formats with
InvariantCulture, so every machine renders 10:32 (a da-DK box without it would render 10.32).
```
