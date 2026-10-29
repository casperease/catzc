function Resolve-BicepRuntimeSlotNames {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepTemplate] $TemplateDescriptor,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $Parameters,

        [string] $ResourceGroup,

        [Parameter(Mandatory)]
        [string] $Environment,

        [string] $Customer,

        [Parameter(Mandatory)]
        [ValidatePattern('(?-i)^[a-z0-9]{1,3}$')]
        [string] $RuntimeSlot,

        [hashtable] $CandidateSet
    )

    $candidates = $CandidateSet
    if ($null -eq $candidates) {
        $candidates = Get-BicepNameCandidateSet
    }
    $naming = Get-Naming
    $azure = Get-Config -Config azure
    $notNames = [string[]] @((Get-Config -Config resource-types).not_names)
    $template = $TemplateDescriptor.name
    $runtime = $RuntimeSlot
    $baseEnvironment = $Environment
    $baseCustomer = $Customer

    $renderName = {
        param([string] $Name, [string] $Location)
        try {
            $components = ConvertFrom-AzureResourceName -Name $Name -CandidateSet $candidates -Order $naming
        }
        catch [System.Management.Automation.MethodInvocationException] {
            throw "${Location} of template '$template': '$Name' has no single canonical match, so runtime slot '$runtime' cannot derive its name: $($_.Exception.InnerException.Message)"
        }
        if ($components.short_name -cne $TemplateDescriptor.short_name -or $components.env -cne $baseEnvironment -or
            "$($components.customer)" -cne "$baseCustomer" -or "$($components.slot)" -cne '') {
            return $Name
        }
        $nameArgs = @{
            Env        = $components.env
            Shortcode  = "$($azure.environments[$components.env].shortcode)"
            RegionCode = $components.region
            Org        = "$($azure.org)"
            ShortName  = $components.short_name
            Type       = $components.type
            Slot       = $runtime
            Order      = $naming
        }
        if ($components.customer) {
            $nameArgs['Customer'] = $components.customer
            $nameArgs['CustomerShortcode'] = "$($candidates.customer[$components.customer])"
        }
        if ($components.role) {
            $nameArgs['Role'] = $components.role
        }
        Get-AzureResourceName @nameArgs
    }

    # The leaves the naming quality gate reads as names (Get-BicepSlotNameLeaf); the walk copies the value and renders only those locations.
    $walk = {
        param([object] $Value, [string] $Location, [System.Collections.Generic.HashSet[string]] $Named)
        if ($Value -is [System.Collections.IDictionary]) {
            $object = [ordered]@{}
            foreach ($key in @($Value.Keys)) {
                $object[$key] = & $walk $Value[$key] "$Location.$key" $Named
            }
            return $object
        }
        if ($Value -is [System.Collections.IList]) {
            $items = for ($index = 0; $index -lt $Value.Count; $index++) {
                , (& $walk $Value[$index] "$Location[$index]" $Named)
            }
            return , [object[]] @($items)
        }
        if ($Value -is [string] -and $Named.Contains($Location)) {
            return & $renderName $Value $Location
        }
        $Value
    }

    $resolved = [ordered]@{}
    foreach ($parameter in @($Parameters.Keys)) {
        $entry = $Parameters[$parameter]
        if ($entry -isnot [System.Collections.IDictionary] -or -not $entry.Contains('value') -or $entry.Contains('naming_exception')) {
            $resolved[$parameter] = $entry
            continue
        }
        $named = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($leaf in @(Get-BicepSlotNameLeaf -Value ([ordered]@{ "$parameter" = $entry.value }) -Location '' -NotNames $notNames)) {
            if ($leaf.named) {
                [void] $named.Add($leaf.location)
            }
        }
        $copy = [ordered]@{}
        foreach ($key in @($entry.Keys)) {
            $copy[$key] = $entry[$key]
        }
        $copy['value'] = & $walk $entry.value "$parameter" $named
        $resolved[$parameter] = $copy
    }

    $group = $ResourceGroup
    if (-not [string]::IsNullOrEmpty($ResourceGroup)) {
        $group = & $renderName $ResourceGroup 'ResourceGroup'
    }
    [ordered]@{
        Parameters    = $resolved
        ResourceGroup = $group
    }
}
