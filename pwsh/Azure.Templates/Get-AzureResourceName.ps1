# cspell:ignore weuzctsmplst
function Get-AzureResourceName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Env,
        [string] $Shortcode,
        [Parameter(Mandatory)] [string] $RegionCode,
        [Parameter(Mandatory)] [string] $Org,
        [Parameter(Mandatory)] [string] $ShortName,
        [Parameter(Mandatory)]
        [ArgumentCompleter({ (Get-AzureResourceTypeSet).Keys })]
        [string] $Type,
        [string] $Slot,
        [string] $Customer,
        [string] $CustomerShortcode,
        [string] $Role,
        [ArgumentCompleter({ (Get-AzureNameOrderSet).Keys })]
        [object] $Order = (Get-Naming)
    )

    $types = Get-AzureResourceTypeSet
    Assert-True $types.Contains($Type) -ErrorText "Unknown resource type '$Type' (known: $(@($types.Keys) -join ', '))"
    $sequence = Resolve-AzureNameOrder -Order $Order

    $specification = $types[$Type]
    $patterns = Get-AzureNamePatternSet
    Assert-True $patterns.Contains($specification.pattern) -ErrorText "Type '$Type' references unknown name pattern '$($specification.pattern)' (known: $(@($patterns.Keys) -join ', '))"
    $pattern = $patterns[$specification.pattern]

    # A type may omit components (the vm's 15-char cap drops org, customer and role, which the resource group encodes); type is never omitted.
    $omit = [Catzc.Azure.Templates.AzureNameRenderer]::Omit($specification)

    # The generous long pattern gets the readable env name, the restricted patterns the 2-char shortcode; only a restricted form can be empty.
    $envValue = [Catzc.Azure.Templates.AzureNameRenderer]::ComponentForm($specification.pattern, $Env, $Shortcode)
    Assert-False ([string]::IsNullOrEmpty($envValue)) -ErrorText "Type '$Type' uses the restricted '$($specification.pattern)' pattern and needs a -Shortcode"

    # The customer follows the same split as env, and applies only when one is given.
    $customerValue = ''
    if ((-not [string]::IsNullOrEmpty($Customer)) -and ('customer' -notin $omit)) {
        $customerValue = [Catzc.Azure.Templates.AzureNameRenderer]::ComponentForm($specification.pattern, $Customer, $CustomerShortcode)
        Assert-False ([string]::IsNullOrEmpty($customerValue)) -ErrorText "Type '$Type' uses the restricted '$($specification.pattern)' pattern and needs a -CustomerShortcode when -Customer is set"
    }

    # Every component is checked case-sensitively as lowercase.
    $checks = [ordered]@{
        Env        = @{ value = $Env; pattern = '^[a-z][a-z0-9]+$'; desc = '2+ alphanumeric, leading letter' }
        RegionCode = @{ value = $RegionCode; pattern = '^[a-z]{3}$'; desc = '3 lowercase letters' }
        Org        = @{ value = $Org; pattern = '^[a-z][a-z0-9]{1,2}$'; desc = '2-3 alphanumeric, leading letter' }
        ShortName  = @{ value = $ShortName; pattern = '^[a-z][a-z0-9]{1,4}$'; desc = '2-5 alphanumeric, leading letter' }
        Type       = @{ value = $Type; pattern = '^[a-z]{2,5}$'; desc = '2-5 lowercase letters' }
    }
    if (-not [string]::IsNullOrEmpty($Shortcode)) {
        $checks['Shortcode'] = @{ value = $Shortcode; pattern = '^[a-z]{2}$'; desc = '2 lowercase letters' }
    }
    if (-not [string]::IsNullOrEmpty($Slot)) {
        $checks['Slot'] = @{ value = $Slot; pattern = '^[a-z0-9]{1,3}$'; desc = '1-3 alphanumeric' }
    }
    if (-not [string]::IsNullOrEmpty($Customer)) {
        $checks['Customer'] = @{ value = $Customer; pattern = '^[a-z][a-z0-9]+$'; desc = '2+ alphanumeric, leading letter' }
    }
    if (-not [string]::IsNullOrEmpty($CustomerShortcode)) {
        $checks['CustomerShortcode'] = @{ value = $CustomerShortcode; pattern = '^[a-z]{2}$'; desc = '2 lowercase letters' }
    }
    if (-not [string]::IsNullOrEmpty($Role)) {
        $checks['Role'] = @{ value = $Role; pattern = '^[a-z][a-z0-9]{1,2}$'; desc = '2-3 alphanumeric, leading letter' }
    }
    foreach ($component in $checks.Keys) {
        $check = $checks[$component]
        Assert-True ($check.value -cmatch $check.pattern) -ErrorText "Invalid $component '$($check.value)' — must be $($check.desc), lowercase."
    }

    $values = @{
        env        = $envValue
        slot       = $Slot
        region     = $RegionCode
        org        = $Org
        short_name = $ShortName
        customer   = $customerValue
        role       = $Role
        type       = $Type
    }

    [Catzc.Azure.Templates.AzureNameRenderer]::Render($values, $sequence, $specification, $pattern)
}
