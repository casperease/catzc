<#
---
catzc:
  immutable:
    with_body_sha: "6174e830c7f3"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureResourceName.Tests.ps1
    docs: "[Get-AzureResourceName.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md)"
    cites:
      - ADR-AZ-NAMING
---
#>

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
        [string] $Order = 'standard'
    )

    $types = Get-AzureResourceTypeSet
    if (-not $types.Contains($Type)) {
        throw "Unknown resource type '$Type' (known: $(@($types.Keys) -join ', '))"
    }
    $orders = Get-AzureNameOrderSet
    if (-not $orders.Contains($Order)) {
        throw "Unknown name order '$Order' (known: $(@($orders.Keys) -join ', '))"
    }

    $specification = $types[$Type]
    $patterns = Get-AzureNamePatternSet
    if (-not $patterns.Contains($specification.pattern)) {
        throw "Type '$Type' references unknown name pattern '$($specification.pattern)' (known: $(@($patterns.Keys) -join ', '))"
    }
    $pattern = $patterns[$specification.pattern]

    $omit = if ($specification.Contains('omit')) {
        @($specification.omit)
    }
    else {
        @()
    }

    $envValue = if ($specification.pattern -eq 'long') {
        $Env
    }
    else {
        if ([string]::IsNullOrEmpty($Shortcode)) {
            throw "Type '$Type' uses the restricted '$($specification.pattern)' pattern and needs a -Shortcode"
        }
        $Shortcode
    }

    $customerValue = ''
    if ((-not [string]::IsNullOrEmpty($Customer)) -and ('customer' -notin $omit)) {
        $customerValue = if ($specification.pattern -eq 'long') {
            $Customer
        }
        else {
            if ([string]::IsNullOrEmpty($CustomerShortcode)) {
                throw "Type '$Type' uses the restricted '$($specification.pattern)' pattern and needs a -CustomerShortcode when -Customer is set"
            }
            $CustomerShortcode
        }
    }

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
        if ($check.value -cnotmatch $check.pattern) {
            throw "Invalid $component '$($check.value)' — must be $($check.desc), lowercase."
        }
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

    # Render each segment (fuse its present components); drop empty segments.
    $segments = foreach ($segment in $orders[$Order]) {
        $present = foreach ($component in $segment) {
            if ($component -in $omit) {
                continue
            }
            if (-not [string]::IsNullOrEmpty($values[$component])) {
                $values[$component]
            }
        }
        if ($present) {
            -join $present
        }
    }
    $segments = @($segments | Where-Object { $_ })

    # The limit is the pattern's intrinsic cap (kv/storage/vm) or — for `long` — the type's own.
    $limit = if ($pattern.Contains('limit')) {
        $pattern.limit
    }
    elseif ($specification.Contains('limit')) {
        $specification.limit
    }
    else {
        throw "Type '$Type' (pattern '$($specification.pattern)') has no length limit"
    }

    $name = $segments -join $pattern.separator

    if ($name.Length -gt $limit) {
        throw "Resource name '$name' ($($name.Length) chars) exceeds the '$Type' limit of $limit — shorten short_name / slot / customer / role."
    }

    $name
}
