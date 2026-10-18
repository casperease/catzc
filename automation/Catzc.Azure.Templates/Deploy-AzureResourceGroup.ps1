<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/Deploy-AzureResourceGroup.ps1
    name: deploy-azure-resource-group
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Templates/tests/Deploy-AzureResourceGroup.Tests.ps1
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
