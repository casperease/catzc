# pwsh/Azure.Firewall/tests/Convert-FirewallCsvToMarkdown.Tests.ps1

The L0 tests of the CSV-to-Markdown conversion: the table content, the column handling and the rule order.

## Group priorities

The fixtures use the groups `rcg-baseline`, `rcg-app` and `rcg-shared`, which the function's default group priorities do not know. The
tests supply priorities, so the evaluation-order sort under test means something.

## The order check

Group priority dominates collection priority, so the lowest group's first rule leads and the catch-all deny comes last:

- `rcg-baseline` (100): `Allow_DNS` (200) and `Allow_NTP` (210);
- `rcg-app` (200): starts at `Allow_OnPrem_SQL` (300);
- `rcg-shared` (300): `Allow_Ping_Mgmt` (400) onward, ending with `Deny_All_Network` (3100) last.
