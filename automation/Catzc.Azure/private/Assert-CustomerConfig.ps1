<#
.SYNOPSIS
    Validates configs/customer.yml and throws with all violations collected.
.DESCRIPTION
    The customer catalogue — the customers this repo can deploy for (split out of azure.yml; see
    docs/adr/azure/azure-customer-model.md).

    Required shape:
      customers:  map; name -> { shortcode [, details] }   (empty map allowed)

    Integrity rules:
    - customer name (the map key) is 2+ lowercase alphanumeric, leading letter (the relaxed-name
      customer-segment + the config subfolder + a value the subscription `customer` field may name)
    - customer `shortcode` is exactly 2 lowercase letters (the restricted-pattern customer-segment)
    - shortcodes are unique
    - NO key equals any shortcode — a subscription's `customer` field may name a customer by its key OR
      its shortcode, so a key that collides with a shortcode would make that reference ambiguous

    Self-contained — it does NOT read azure.yml (a subscription references a customer here, so azure.yml
    depends on customer.yml, not the reverse; that keeps validation one-directional and cycle-free).
    Auto-dispatched by Get-Config when loading the 'customer' config.
#>
function Assert-CustomerConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not $Config.Contains('customers')) {
        throw "customer configuration validation failed:`nMissing required top-level key: 'customers'"
    }

    $errors = [System.Collections.Generic.List[string]]::new()

    $customerNames = @($Config.customers.Keys)
    $shortcodes = @()
    foreach ($name in $customerNames) {
        if ("$name" -cnotmatch '^[a-z][a-z0-9]+$') {
            $errors.Add("customer name '$name' is invalid (must be 2+ lowercase alphanumeric chars, leading letter)")
        }
        $entry = $Config.customers[$name]
        if (-not $entry.Contains('shortcode')) {
            $errors.Add("customer '$name' is missing 'shortcode'")
        }
        elseif ("$($entry.shortcode)" -cnotmatch '^[a-z]{2}$') {
            $errors.Add("customer '$name' has invalid shortcode '$($entry.shortcode)' (must be 2 lowercase letters)")
        }
        else {
            $shortcodes += "$($entry.shortcode)"
        }
    }

    $duplicateShortcodes = $shortcodes | Group-Object | Where-Object Count -GT 1
    foreach ($duplicate in $duplicateShortcodes) {
        $errors.Add("Duplicate customer shortcode: '$($duplicate.Name)'")
    }

    # A subscription binds a customer by key OR shortcode, so the two name-spaces must not collide.
    $collisions = @($customerNames | Where-Object { "$_" -in $shortcodes })
    foreach ($collision in $collisions) {
        $errors.Add("customer name '$collision' collides with a customer shortcode — keys and shortcodes must be distinct so a subscription's 'customer' reference is unambiguous")
    }

    if ($errors.Count -gt 0) {
        throw "customer configuration validation failed:`n$($errors -join "`n")"
    }
}
