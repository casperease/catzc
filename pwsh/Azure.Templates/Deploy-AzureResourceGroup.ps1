function Deploy-AzureResourceGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId,

        [Parameter(Mandatory, Position = 1)]
        [string] $Region,

        [Parameter(Mandatory, Position = 2)]
        [string] $ResourceGroup,

        # The CAF tags the group carries, as its template's resources do; a group that exists gets them merged in.
        [System.Collections.IDictionary] $Tags = @{},

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $SubscriptionId
    Assert-NotNullOrWhitespace $Region
    Assert-NotNullOrWhitespace $ResourceGroup

    Write-Message "Ensuring resource group exists: $ResourceGroup (subscription $SubscriptionId, region $Region)"

    $tagArguments = @($Tags.Keys | Sort-Object | ForEach-Object { "`"$_=$($Tags[$_])`"" })

    $existsResult = Invoke-AzCli "group exists --name `"$ResourceGroup`" --subscription $SubscriptionId" -PassThru
    if ($existsResult.Output.Trim() -eq 'true') {
        if ($tagArguments.Count -eq 0) {
            Write-Message "Resource group '$ResourceGroup' already exists — skipped"
            return [ordered]@{ name = $ResourceGroup; provisioning_state = 'Skipped' }
        }
        if ($DryRun) {
            Write-Message "DryRun: would merge $($tagArguments.Count) tag(s) onto '$ResourceGroup'"
            return [ordered]@{ name = $ResourceGroup; provisioning_state = 'DryRun' }
        }
        # Merge, never replace: a tag another tool set on the group stays.
        $id = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup"
        Invoke-AzCli "tag update --resource-id `"$id`" --operation Merge --tags $($tagArguments -join ' ') --output none" | Out-Null
        Write-Message "Resource group '$ResourceGroup' already exists — its tags merged"
        return [ordered]@{ name = $ResourceGroup; provisioning_state = 'Tagged' }
    }

    if ($DryRun) {
        Write-Message "DryRun: would create '$ResourceGroup' in $Region"
        return [ordered]@{ name = $ResourceGroup; provisioning_state = 'DryRun' }
    }

    $tagOption = if ($tagArguments.Count -gt 0) {
        " --tags $($tagArguments -join ' ')"
    }
    else {
        ''
    }
    $createResult = Invoke-AzCli "group create --name `"$ResourceGroup`" --location $Region --subscription $SubscriptionId$tagOption --output yaml" -PassThru
    $object = $createResult.Output | ConvertFrom-Yaml
    if ($object.properties.provisioningState -ne 'Succeeded') {
        throw "Failed to create resource group '$ResourceGroup' (state: $($object.properties.provisioningState))"
    }
    [ordered]@{ name = $ResourceGroup; provisioning_state = 'Succeeded' }
}
