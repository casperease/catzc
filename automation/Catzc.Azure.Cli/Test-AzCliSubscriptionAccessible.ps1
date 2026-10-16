<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
    name: test-az-cli-subscription-accessible
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Test-AzCliSubscriptionAccessible.Tests.ps1
    cites:
      - ADR-AZ-CLI#1
  config:
    synopsis: Tests whether the current az CLI login can reach a given subscription.
    description: |-
      Returns $true when a real, read-only ARM call scoped to the subscription succeeds with the current
      login; $false otherwise (including not logged in). A pure query — it never throws on a mismatch.
      Use Assert-AzCliSubscriptionAccessible for the throwing companion. Both share
      Get-AzCliSubscriptionAccessState.

      Unlike Test-AzCliConnected (which asks "is this subscription the active one?"), this asks "can my
      current login reach this subscription?", independent of the active context — the question to ask
      before a call that supplies `--subscription <id>`.
      See [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).
    parameters:
      SubscriptionId: The subscription GUID the current login must be able to reach.
    examples:
      - if (Test-AzCliSubscriptionAccessible -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000) { ... }
---
#>

function Test-AzCliSubscriptionAccessible {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId
    )

    (Get-AzCliSubscriptionAccessState $SubscriptionId).accessible
}
