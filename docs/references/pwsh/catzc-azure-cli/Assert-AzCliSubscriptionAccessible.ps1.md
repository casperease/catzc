# pwsh/Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts the current az CLI login can reach a given subscription.

### description

The throwing companion to Test-AzCliSubscriptionAccessible. Throws a remediation-bearing error when az is not logged in, or is logged in but
cannot reach the subscription passed by argument. Drop it at the top of any function that is about to call az against a subscription —
whether that subscription is the active one or supplied via `--subscription <id>` — to fail fast with a clear message instead of deep inside
the later call.

The check is a real, read-only ARM call (see Get-AzCliSubscriptionAccessState), so a pass proves the later call will actually reach ARM, not
merely that the subscription is in the local profile. The generic, azure.yml-free primitive. Both Assert/Test share
Get-AzCliSubscriptionAccessState. See [ADR-AZ-CLI-AZBYDEFAULT](../../../drs/azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault) and
[ADR-AUTO-FAILFAST](../../../drs/automation/fail-fast-with-asserts.md).

### parameter `SubscriptionId`

The subscription GUID the current login must be able to reach.

### example 1

```powershell
Assert-AzCliSubscriptionAccessible -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000
```
