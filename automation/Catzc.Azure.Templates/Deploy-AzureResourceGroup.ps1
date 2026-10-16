<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Deploy-AzureResourceGroup.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure.Templates/tests/Deploy-AzureResourceGroup.Tests.ps1
  config:
    synopsis: Idempotently ensures a resource group exists in a given subscription and region.
    description: |-
      Runs `az group exists`; if missing, runs `az group create` at the given region in the given
      subscription. The subscription + region are resolved by the caller (Deploy-Bicep, from the
      deployment context) and passed in — this function does NOT re-resolve them from azure.yml, so the RG
      is always created in the SAME subscription the deployment targets (including customer deploys).

      Returns an ordered dictionary `{ name, provisioning_state }` where provisioning_state is
      'Succeeded' (just created), 'Skipped' (already existed), or 'DryRun'.
    parameters:
      SubscriptionId: The subscription the resource group must live in (from the resolved deployment context).
      Region: The Azure region to create the resource group in.
      ResourceGroup: The resource group name to ensure.
      DryRun: Preview only — report the resource group that would be created and make no change.
    examples:
      - Deploy-AzureResourceGroup -SubscriptionId $context.environment.subscription.id -Region westeurope -ResourceGroup rg-sample-dev
---
#>

function Deploy-AzureResourceGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId,

        [Parameter(Mandatory, Position = 1)]
        [string] $Region,

        [Parameter(Mandatory, Position = 2)]
        [string] $ResourceGroup,

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $SubscriptionId
    Assert-NotNullOrWhitespace $Region
    Assert-NotNullOrWhitespace $ResourceGroup

    Write-Message "Ensuring resource group exists: $ResourceGroup (subscription $SubscriptionId, region $Region)"

    $existsResult = Invoke-AzCli "group exists --name `"$ResourceGroup`" --subscription $SubscriptionId" -PassThru
    if ($existsResult.Output.Trim() -eq 'true') {
        Write-Message "Resource group '$ResourceGroup' already exists — skipped"
        return [ordered]@{ name = $ResourceGroup; provisioning_state = 'Skipped' }
    }

    if ($DryRun) {
        Write-Message "DryRun: would create '$ResourceGroup' in $Region"
        return [ordered]@{ name = $ResourceGroup; provisioning_state = 'DryRun' }
    }

    $createResult = Invoke-AzCli "group create --name `"$ResourceGroup`" --location $Region --subscription $SubscriptionId --output yaml" -PassThru
    $object = $createResult.Output | ConvertFrom-Yaml
    if ($object.properties.provisioningState -ne 'Succeeded') {
        throw "Failed to create resource group '$ResourceGroup' (state: $($object.properties.provisioningState))"
    }
    [ordered]@{ name = $ResourceGroup; provisioning_state = 'Succeeded' }
}
