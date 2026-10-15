<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
    kind: public-function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AZ-NAMING
      - ADR-AZ-NAMING#4
      - ADR-AZ-NAMING#6
  config:
    synopsis: Assembles a deterministic Azure resource name from the standard component set.
    description: |-
      Resolves the component VALUES (env, slot, region, org, short_name, [customer], [role], type) and
      arranges them per the selected order from Get-AzureNameOrderSet:

        standard — <env>-<slot>-<region>-<org>-<short_name>[-<customer>][-<role>]-<type>
        classic  — <type>-<org>-<short_name>[-<customer>]-<env>-<region>[-<slot>][-<role>]

      The env-segment value is chosen by the type's pattern: generous (`long`) types render the readable
      env NAME (-Env); restricted (`kv`/`storage`/`vm`) types render the 2-char SHORTCODE (-Shortcode),
      so a long name never costs a tight name a byte. `env` and `slot` are separate segments; segments
      are joined by the pattern's render separator (a hyphen for `long`/`kv`, nothing for `storage`/`vm`
      — Get-AzureNamePatternSet). Every component is format-validated (case-sensitive, lowercase). The
      assembled name is asserted against the type's limit; on overflow it throws, naming the components
      to shorten. Names are deterministic — no random suffixes.
    parameters:
      Env: Environment name (azure.yml env key, e.g. `develop`). The env-segment of generous (`long`) types.
      Shortcode: |-
        2-letter environment shortcode (azure.yml env `shortcode`, e.g. `de`). The env-segment of the
        restricted patterns; required when Type is restricted.
      RegionCode: 3-letter region code (azure.yml env `region_code`, e.g. `weu`).
      Org: Vertical/organization shortcode (azure.yml top-level `org`, 2-3 alnum).
      ShortName: Template id segment (options.yml `short_name`, 2-5 alnum, globally unique).
      Type: Resource-type abbreviation — a key of Get-AzureResourceTypeSet (`rg`, `st`, `kv`, …).
      Slot: Optional special-slot discriminator — 1-3 lowercase alphanumeric chars (`001`, `blu`, …).
      Customer: Optional customer / sub-tenant. The readable key (the customer-segment of generous `long` types).
      CustomerShortcode: |-
        2-letter customer shortcode (azure.yml customer `shortcode`). The customer-segment of the restricted
        patterns; required when both -Customer is set and Type is restricted.
      Role: Optional 2-3 char sibling discriminator among same-type resources (per resource).
      Order: Name component order — a key of Get-AzureNameOrderSet (default `standard`).
    examples:
      - |-
        Get-AzureResourceName -Env develop -Slot 001 -RegionCode weu -Org zct -ShortName smpl -Type rg
        # -> develop-001-weu-zct-smpl-rg
      - |-
        Get-AzureResourceName -Env develop -Shortcode de -Slot 001 -RegionCode weu -Org zct -ShortName smpl -Type st
        # -> de001weuzctsmplst
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

    # A type may omit components from its render — e.g.
    # [comment:8](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment8)
    $omit = if ($specification.Contains('omit')) {
        @($specification.omit)
    }
    else {
        @()
    }

    # The env-segment is the readable name for the generous `long` pattern, the 2-char shortcode for the restricted...
    # [comment:9](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment9)
    $envValue = if ($specification.pattern -eq 'long') {
        $Env
    }
    else {
        if ([string]::IsNullOrEmpty($Shortcode)) {
            throw "Type '$Type' uses the restricted '$($specification.pattern)' pattern and needs a -Shortcode"
        }
        $Shortcode
    }

    # Customer follows the same pattern-chosen split as env: the readable key (-Customer) for the generous `long`...
    # [comment:10](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment10)
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

    # Component format checks (case-sensitive, lowercase) — see.
    # [comment:11](/docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md#comment11)
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
