# docs/references/automation/catzc-azure-cli/Get-CurrentAzSubscription.ps1.md

`automation/Catzc.Azure.Cli/Get-CurrentAzSubscription.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Thin wrapper over `az account show` (via Invoke-AzCli) returning the active subscription as an object
(Id, Name, TenantId, State, IsDefault). This is a data read, so the underlying call is silenced.
Throws with remediation when there is no active context (e.g. not logged in).

Pairs with Set-CurrentAzSubscription for a save / switch / restore idiom:
    $original = Get-CurrentAzSubscription
    try     { Set-CurrentAzSubscription -SubscriptionId $target; do-stuff}
    finally { Set-CurrentAzSubscription -SubscriptionId $original.Id }
```
