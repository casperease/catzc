<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
    name: get-az-cli-subscription-access-state
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md
    test: automation/Catzc.Azure.Cli/tests/Get-AzCliSubscriptionAccessState.Tests.ps1
    cites:
      - ADR-AZ-CLI#1
  config:
    synopsis: Returns whether the current az CLI login can actually reach a given subscription.
    description: |-
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
      so the two cannot drift. See
      [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).

      Returns an ordered dictionary:
        { logged_in, accessible, subscription, detail }
      `accessible` is true only when the scoped ARM probe exits zero. On failure, `logged_in`
      distinguishes "not logged in at all" from "logged in but no access to this subscription" (a local
      `az account show`, run only on the error path) so callers can name the right remediation.
    parameters:
      SubscriptionId: The subscription GUID the current login must be able to reach.
    examples:
      - (Get-AzCliSubscriptionAccessState -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000).accessible
---
#>

function Get-AzCliSubscriptionAccessState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId
    )

    Assert-IsGuid $SubscriptionId

    $probe = Invoke-AzCli "account list-locations --subscription $SubscriptionId -o none" -PassThru -NoAssert -Silent
    if ($probe.ExitCode -eq 0) {
        return [Catzc.Azure.Cli.SubscriptionAccessState]::new($true, $true, $SubscriptionId, $null)
    }

    $session = Invoke-AzCli 'account show -o none' -PassThru -NoAssert -Silent

    [Catzc.Azure.Cli.SubscriptionAccessState]::new(($session.ExitCode -eq 0), $false, $SubscriptionId, ($probe.Errors | Select-Object -First 1))
}
