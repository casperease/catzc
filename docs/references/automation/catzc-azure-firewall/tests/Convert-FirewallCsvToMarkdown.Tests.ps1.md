---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/tests/Convert-FirewallCsvToMarkdown.Tests.ps1.md
    kind: test-asset
    body_sha: "2005e62708b0"
---

# automation/Catzc.Azure.Firewall/tests/Convert-FirewallCsvToMarkdown.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:groupPriority = @{ 'rcg-baseline' = 100; 'rcg-app' = 200;...`.

```text
The fixtures use rcg-baseline / rcg-app / rcg-shared; the function's default GroupPriority only
knows rcg-old/rcg-new. Supply priorities so the evaluation-order sort is meaningful.
```

## comment:2

Above `$order[0] | Should -Be 'Allow_DNS'`.

```text
rcg-baseline(100): Allow_DNS(200), Allow_NTP(210) | rcg-app(200): starts at Allow_OnPrem_SQL(300)
| rcg-shared(300): Allow_Ping_Mgmt(400) ... Deny_All_Network(3100) last.
```
