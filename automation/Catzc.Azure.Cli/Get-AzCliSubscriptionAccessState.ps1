<#
.SYNOPSIS
    Returns whether the current az CLI login can actually reach a given subscription.
.DESCRIPTION
    The access counterpart to Get-AzCliConnectionState. Where the connection-state primitive asks
    "is this subscription the *active* one?" (a local `az account show` read), this primitive asks
    "can my current login *reach* this subscription right now?" — independent of which subscription is
    active. That distinction matters because az CLI commands accept `--subscription <id>`: a function
    can operate against a subscription it is not "set to", so before it does, it should assert the
    later call will succeed.

    To prove a later real call will work, this makes a REAL, read-only ARM call scoped to the
    subscription (`az account list-locations --subscription <id>`) — not a local profile read.
    Succeeding proves the current login holds a valid token with access to that subscription. A local
    `az account show` would not: it only reports the on-disk profile and never touches ARM, so it
    cannot tell an expired token or a revoked role from a working one.

    The generic, azure.yml-free primitive — the single source of the check shared by
    Test-AzCliSubscriptionAccessible (returns a bool) and Assert-AzCliSubscriptionAccessible (throws),
    so the two cannot drift. See docs/adr/automation/powershell/prefer-az-cli.md#rule-adr-auto-azcli1.

    Returns an ordered dictionary:
      { logged_in, accessible, subscription, detail }
    `accessible` is true only when the scoped ARM probe exits zero. On failure, `logged_in`
    distinguishes "not logged in at all" from "logged in but no access to this subscription" (a local
    `az account show`, run only on the error path) so callers can name the right remediation.
.PARAMETER SubscriptionId
    The subscription GUID the current login must be able to reach.
.EXAMPLE
    (Get-AzCliSubscriptionAccessState -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000).accessible
#>
function Get-AzCliSubscriptionAccessState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId
    )

    Assert-IsGuid $SubscriptionId

    # A REAL, read-only ARM call scoped to the subscription. Exit zero proves the current login can
    # reach it via `--subscription`, whether or not it is the active subscription.
    $probe = Invoke-AzCli "account list-locations --subscription $SubscriptionId -o none" -PassThru -NoAssert -Silent
    if ($probe.ExitCode -eq 0) {
        return [Catzc.Azure.Cli.SubscriptionAccessState]::new($true, $true, $SubscriptionId, $null)
    }

    # The probe failed. Distinguish "not logged in" from "logged in but cannot reach this subscription"
    # with a local read (only on the error path) so the error names the right fix.
    $session = Invoke-AzCli 'account show -o none' -PassThru -NoAssert -Silent

    [Catzc.Azure.Cli.SubscriptionAccessState]::new(($session.ExitCode -eq 0), $false, $SubscriptionId, ($probe.Errors | Select-Object -First 1))
}
