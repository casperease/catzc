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

    # Addressed parameters resolve to their value before the hook, so the hook and the parameters file see only ARM entries.
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
        # The addresses options.yml declares join the slot's own, so one resolution reads them all; a slot that sets one is refused.
        foreach ($parameter in @($TemplateDescriptor.addresses.Keys)) {
            if ($configurationDescriptor.ParametersFile.parameters.Contains($parameter)) {
                throw "Slot '$($Slot.name)' of template '$template' writes '$parameter', a shared value of the template (options.yml addresses): delete it from the slot"
            }
            $configurationDescriptor.ParametersFile.parameters[$parameter] = [ordered]@{ address = $TemplateDescriptor.addresses[$parameter] }
        }
        $configurationDescriptor.ParametersFile.parameters = Resolve-BicepParameterAddresses -Parameters $configurationDescriptor.ParametersFile.parameters -ConfigFile (Join-Path $configFolder "$($Slot.name).yml")
    }

    $slotParameters = $configurationDescriptor.ParametersFile.parameters
    $derivedNames = Resolve-BicepDerivedNames -TemplateDescriptor $TemplateDescriptor -Slot $Slot -SlotParameters $slotParameters
    foreach ($parameter in @($derivedNames.Keys)) {
        if (-not $TemplateDescriptor.names[$parameter].each -and $slotParameters.Contains($parameter)) {
            throw "Slot '$($Slot.name)' of template '$template' writes '$parameter', a name the namer derives (options.yml names): delete it from the slot"
        }
        $slotParameters[$parameter] = [ordered]@{ value = $derivedNames[$parameter] }
    }

    # The facts options.yml declares come from the slot's azure.yml environment the same way; a slot that writes one is refused.
    $environmentFacts = Resolve-BicepEnvironmentFacts -TemplateDescriptor $TemplateDescriptor -Slot $Slot
    foreach ($parameter in @($environmentFacts.Keys)) {
        if ($slotParameters.Contains($parameter)) {
            throw "Slot '$($Slot.name)' of template '$template' writes '$parameter', a fact of its environment (options.yml facts): delete it from the slot"
        }
        $slotParameters[$parameter] = [ordered]@{ value = $environmentFacts[$parameter] }
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
