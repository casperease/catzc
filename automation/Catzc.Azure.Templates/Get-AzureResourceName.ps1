<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AZ-NAMING
      - ADR-AZ-NAMING#4
      - ADR-AZ-NAMING#6
---
#>

# cspell:ignore weuzctsmplst
<#
.SYNOPSIS
    Assembles a deterministic Azure resource name from the standard component set.
.DESCRIPTION
    Restricted types render the 2-char shortcode, so a long env name never costs a tight name a byte.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment1)
.PARAMETER Env
    Environment name (azure.yml env key, e.g. `develop`). The env-segment of generous (`long`) types.
.PARAMETER Shortcode
    Required when Type is restricted; the long pattern uses the readable Env name instead.
    [comment:2](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment2)
.PARAMETER RegionCode
    3-letter region code (azure.yml env `region_code`, e.g. `weu`).
.PARAMETER Org
    Vertical/organization shortcode (azure.yml top-level `org`, 2-3 alnum).
.PARAMETER ShortName
    Template id segment (options.yml `short_name`, 2-5 alnum, globally unique).
.PARAMETER Type
    Resource-type abbreviation — a key of Get-AzureResourceTypeSet (`rg`, `st`, `kv`, …).
.PARAMETER Slot
    Optional special-slot discriminator — 1-3 lowercase alphanumeric chars (`001`, `blu`, …).
.PARAMETER Customer
    Optional customer / sub-tenant. The readable key (the customer-segment of generous `long` types).
.PARAMETER CustomerShortcode
    Required only when -Customer is set and Type is restricted; long types use the readable customer key.
    [comment:3](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment3)
.PARAMETER Role
    Optional 2-3 char sibling discriminator among same-type resources (per resource).
.PARAMETER Order
    Name component order — a key of Get-AzureNameOrderSet (default `standard`).
.EXAMPLE
    Get-AzureResourceName -Env develop -Slot 001 -RegionCode weu -Org zct -ShortName smpl -Type rg
    # -> develop-001-weu-zct-smpl-rg
.EXAMPLE
    Get-AzureResourceName -Env develop -Shortcode de -Slot 001 -RegionCode weu -Org zct -ShortName smpl -Type st
    # -> de001weuzctsmplst
#>
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

    # The type segment is never omitted; vm drops org, customer and role since the resource group encodes them.
    # [ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)
    # [comment:4](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment4)
    $omit = if ($specification.Contains('omit')) {
        @($specification.omit)
    }
    else {
        @()
    }

    # Only restricted patterns get the 2-char shortcode, so the readable env name never costs a tight name a byte.
    # [ADR-AZ-NAMING#4](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming4)
    # [comment:5](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment5)
    $envValue = if ($specification.pattern -eq 'long') {
        $Env
    }
    else {
        if ([string]::IsNullOrEmpty($Shortcode)) {
            throw "Type '$Type' uses the restricted '$($specification.pattern)' pattern and needs a -Shortcode"
        }
        $Shortcode
    }

    # The customer segment is optional, so none of this applies when no customer is given.
    # [comment:6](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment6)
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

    # The match is case-sensitive, so any capital letter in a component is a violation.
    # [ADR-AZ-NAMING#6](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming6)
    # [comment:7](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment7)
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
