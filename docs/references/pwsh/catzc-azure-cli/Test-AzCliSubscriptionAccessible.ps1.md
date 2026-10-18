# pwsh/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether the current az CLI login can reach a given subscription.

### description

Returns $true when a real, read-only ARM call scoped to the subscription succeeds with the current
login; $false otherwise (including not
logged in). A pure query — it never throws on a mismatch. Use Assert-AzCliSubscriptionAccessible for the throwing companion. Both share
Get-AzCliSubscriptionAccessState.

Unlike Test-AzCliConnected (which asks "is this subscription the active one?"), this asks "can my current login reach this subscription?",
independent of the active context — the question to ask before a call that supplies `--subscription <id>`. See
[ADR-AZ-CLI-AZBYDEFAULT](../../../adr/azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault).

### parameter `SubscriptionId`

The subscription GUID the current login must be able to reach.

### example 1

```powershell
if (Test-AzCliSubscriptionAccessible -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000) { ... }
```
