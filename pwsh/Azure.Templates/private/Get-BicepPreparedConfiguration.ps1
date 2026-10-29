function Get-BicepPreparedConfiguration {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepTemplate] $TemplateDescriptor,

        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepSlot] $Slot,

        # The template's Invoke-BicepPrepareParameterSet hook, from Get-BicepPrepareHook; absent, the configuration is used unchanged.
        [System.Management.Automation.CommandInfo] $PrepareHook
    )

    $template = $TemplateDescriptor.name
    $configurationDescriptor = Get-BicepTemplateConfiguration $template $Slot.environment -Slot $Slot.slot -Customer $Slot.customer

    $flat = $configurationDescriptor | ConvertTo-FlatSettingSet
    foreach ($key in $flat.Keys) {
        # String-first and case-sensitive: -eq would coerce a boolean true or a number to equal the marker.
        if ($flat[$key] -is [string] -and 'UNDEFINED' -ceq $flat[$key]) {
            throw "Undefined config key '$key' for slot '$($Slot.name)' in template '$template'"
        }
    }

    # Address and fact parameters resolve to their value before the hook, so the hook and the parameters file see only ARM entries.
    if ($configurationDescriptor.Contains('ParametersFile') -and
        $configurationDescriptor.ParametersFile -is [System.Collections.IDictionary] -and
        $configurationDescriptor.ParametersFile.Contains('parameters') -and
        $configurationDescriptor.ParametersFile.parameters -is [System.Collections.IDictionary]) {
        $configFolder = if ([string]::IsNullOrEmpty($Slot.customer)) {
            $TemplateDescriptor.configuration_folder
        }
        else {
            Join-Path $TemplateDescriptor.configuration_folder $Slot.customer
        }
        $configFile = Join-Path $configFolder "$($Slot.name).yml"
        $configurationDescriptor.ParametersFile.parameters = Resolve-BicepParameterAddresses -Parameters $configurationDescriptor.ParametersFile.parameters -ConfigFile $configFile
        $configurationDescriptor.ParametersFile.parameters = Resolve-BicepEnvironmentFacts -Parameters $configurationDescriptor.ParametersFile.parameters -Slot $Slot -ConfigFile $configFile
    }

    $declared = @($TemplateDescriptor.slots | Where-Object { $_.name -eq $Slot.name -and $_.customer -eq $Slot.customer })
    if ($Slot.slot -and $declared.Count -eq 0) {
        if ($configurationDescriptor.ParametersFile.parameters -isnot [System.Collections.IDictionary]) {
            $configurationDescriptor.ParametersFile.parameters = [ordered]@{}
        }
        $runtimeNames = Resolve-BicepRuntimeSlotNames -TemplateDescriptor $TemplateDescriptor -Parameters $configurationDescriptor.ParametersFile.parameters -Environment $Slot.environment -Customer $Slot.customer -RuntimeSlot $Slot.slot
        $configurationDescriptor.ParametersFile.parameters = $runtimeNames.Parameters
    }

    # Hooks read their dimensions from this invocation, not raw params, so a new dimension never changes the hook signature.
    $buildInvocation = [ordered]@{
        Template     = $template
        Environment  = $Slot.environment
        Slot         = $Slot.slot
        Subscription = $Slot.subscription
        Customer     = $Slot.customer
    }
    $preparedDescriptor = if ($PrepareHook) {
        & $PrepareHook -BuildInvocation $buildInvocation -TemplateDescriptor $TemplateDescriptor -ConfigurationDescriptor $configurationDescriptor
    }
    else {
        $configurationDescriptor
    }

    Assert-True ($null -ne $preparedDescriptor) -ErrorText "PrePost Invoke-BicepPrepareParameterSet returned null for $template / $($Slot.name)"
    if (-not $preparedDescriptor.Contains('ParametersFile')) {
        throw "Prepared configuration for $template / $($Slot.name) is missing 'ParametersFile' (check the template's PrePost.psm1)"
    }
    $preparedDescriptor
}
