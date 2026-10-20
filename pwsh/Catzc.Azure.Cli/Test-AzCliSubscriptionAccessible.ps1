<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
    name: test-az-cli-subscription-accessible
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Test-AzCliSubscriptionAccessible.Tests.ps1
    docs: "[Test-AzCliSubscriptionAccessible.ps1.md](docs/references/pwsh/catzc-azure-cli/Test-AzCliSubscriptionAccessible.ps1.md)"
    cites:
      - ADR-AZ-CLI-AZBYDEFAULT
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
