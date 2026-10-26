# pwsh/Catzc.Azure.Firewall/tests/Convert-FirewallCsvToMarkdown.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:groupPriority = @{ 'rcg-baseline' = 100; 'rcg-app' = 200;...`, written with `#`.

```text
The fixtures use rcg-baseline / rcg-app / rcg-shared; the function's default GroupPriority only
knows rcg-old/rcg-new. Supply priorities so the evaluation-order sort is meaningful.
```

## comment:2

Above `$order[0] | Should -Be 'Allow_DNS'`, written with `#`.

```text
rcg-baseline(100): Allow_DNS(200), Allow_NTP(210) | rcg-app(200): starts at Allow_OnPrem_SQL(300)
| rcg-shared(300): Allow_Ping_Mgmt(400) ... Deny_All_Network(3100) last.
```

## comment:3

Above `$script:groupPriority = @{ 'rcg-baseline' = 100; 'rcg-app' = 200;...`, written with `#`.

```text
The fixture groups are unknown to the default priorities, so they are supplied here and the order under test
means something.
```

## comment:4

Above `$order[0] | Should -Be 'Allow_DNS'`, written with `#`.

```text
Group priority dominates collection priority, so the lowest group's first rule leads and the catch-all
deny comes last.
```
