<#
.SYNOPSIS
    Validates configs/azure.yml and throws with all violations collected.
.DESCRIPTION
    Required shape:
      org:                 top-level vertical/organization shortcode (2-3 lowercase alphanumeric)
      bicep_min_version:   minimum Bicep CLI version (MAJOR.MINOR.PATCH); asserted before az bicep build
      tenants:             map; name -> { id }
      subscriptions:       map; name -> { id, tenant, environments [, customer | family] }
                           customer: OPTIONAL — a reference to a customer in customer.yml, by its key OR its
                                     2-char shortcode. Its presence marks a customer subscription; the
                                     customer renders into resource names, and its canonical key is the
                                     subscription's family. Allowed on any subscription.
                           family:   OPTIONAL — the family a non-customer subscription belongs to. Never
                                     combined with customer (the customer IS the family).
      environments:        map; name -> { shortcode, region, region_code [, per_subscription] }
                           per_subscription: true marks a once-per-subscription env (subn/subp); absent ⇒ false
      families:            OPTIONAL map; name -> { details? } — configuration for a family beyond the
                           derived defaults. A declared entry must have at least one member subscription.
      (all named entities are maps keyed by name — duplicate names are structurally impossible)
      (customer DEFINITIONS live in customer.yml — see Assert-CustomerConfig / docs/adr/azure/customer-model.md)

    A template targets a FAMILY by naming a config folder after it (configuration/<family>/…); the
    subscription is resolved as the family's one member serving the config's environment. A subscription's
    family is DERIVED: its customer's key when `customer` is set, else its explicit `family:`, else its
    own name. See docs/adr/azure/data-model.md.

    Integrity rules:
    - names are valid lower-snake_case identifiers
    - ids (tenant, subscription) are GUIDs
    - org is 2-3 lowercase alphanumeric chars starting with a letter
    - bicep_min_version is MAJOR.MINOR.PATCH (e.g. 0.30.0)
    - environment name (the map key) is 2+ lowercase alphanumeric, leading letter (the deploy handle)
    - environment `shortcode` is 2 lowercase letters, unique (the tight-pattern env-segment)
    - environment `region_code` is 3 lowercase letters (the <region> name component)
    - subscription.tenant references a defined tenant
    (subscription.customer is a cross-asset reference into customer.yml — enforced by a shipped-asset
     integrity test and at runtime by Get-AzureCustomer, NOT here; see the body comment / customer-model ADR)
    - subscription.environments entries exist in the environments map
    - environment `per_subscription` (if present) is a boolean
    - a subscription lists at most one `per_subscription` environment (its identity env)
    - no duplicate environment `shortcode`s (names are map keys, so name duplicates are impossible)
    - subscription `family` (if present) is 2+ lowercase alphanumeric, leading letter (no underscore —
      the family is the configuration-folder name), and never combined with `customer`
    - within a family, no two member subscriptions serve the same environment (the (family, env) ->
      subscription join must be unique); membership here groups a customer subscription by its RAW
      customer token — the normalized (key-vs-shortcode) grouping is a cross-asset fact covered by the
      shipped-asset integrity test, like the customer reference itself
    - every declared `families:` entry has at least one member subscription (no dead family config)

    Note: completeness ("every environment is served") and uniqueness ("at most one subscription serves
    an env") are NOT validated here. Multiple subscriptions may serve the same env; a template names the
    subscription it deploys to via its config folder, and the deploy-time -Subscription arg disambiguates
    when more than one applies. See docs/adr/azure/data-model.md#rule-adr-datamod7.
#>
function Assert-AzureConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    $identifierPattern = '^[a-z][a-z0-9_]*$'
    $errors = [System.Collections.Generic.List[string]]::new()

    # --- Required top-level keys (customers is optional) ---
    foreach ($key in 'org', 'bicep_min_version', 'tenants', 'subscriptions', 'environments') {
        if (-not $Config.Contains($key)) {
            $errors.Add("Missing required top-level key: '$key'")
        }
    }
    if ($errors.Count -gt 0) {
        throw "azure configuration validation failed:`n$($errors -join "`n")"
    }

    # --- Org (vertical/organization shortcode; the <org> name component) ---
    if ("$($Config.org)" -cnotmatch '^[a-z][a-z0-9]{1,2}$') {
        $errors.Add("org '$($Config.org)' is invalid (must be 2-3 lowercase alphanumeric chars starting with a letter)")
    }

    # --- Bicep minimum version (MAJOR.MINOR.PATCH; asserted by Assert-AzCliBicep before az bicep build) ---
    if ("$($Config.bicep_min_version)" -notmatch '^\d+\.\d+\.\d+$') {
        $errors.Add("bicep_min_version '$($Config.bicep_min_version)' is invalid (must be MAJOR.MINOR.PATCH, e.g. 0.30.0)")
    }

    # --- Tenants (map keyed by name) ---
    $tenantNames = @($Config.tenants.Keys)
    if ($tenantNames.Count -eq 0) {
        $errors.Add('tenants is empty')
    }
    foreach ($tName in $tenantNames) {
        if ($tName -notmatch $identifierPattern) {
            $errors.Add("tenant name '$tName' is not a valid identifier (must match $identifierPattern)")
        }
        $t = $Config.tenants[$tName]
        if (-not $t.Contains('id')) {
            $errors.Add("tenant '$tName' missing 'id'")
        }
        elseif (-not (Test-IsGuid $t.id)) {
            $errors.Add("tenant '$tName' has invalid id '$($t.id)' (must be a GUID)")
        }
    }
    # (no duplicate-name check — map keys are unique by construction)

    # Customer DEFINITIONS live in customer.yml (validated by Assert-CustomerConfig). A subscription's
    # `customer` field is a cross-asset reference into that catalogue (by key OR 2-char shortcode); it is NOT
    # validated here — that would make every azure load read customer.yml and couple ~all azure tests to it.
    # The reference is enforced two other ways: a shipped-asset integrity test (every shipped subscription's
    # customer resolves in customer.yml) and at runtime (Get-AzureCustomer throws on an unknown token). This
    # keeps azure validation hermetic. See docs/adr/azure/customer-model.md.

    # --- Environments ---
    $envKeys = @($Config.environments.Keys)
    if ($envKeys.Count -eq 0) {
        $errors.Add('environments is empty')
    }
    # The env KEY is the readable name (deploy handle + config-file name + relaxed env-segment): 2+
    # lowercase alphanumeric, leading letter, and prefix-free (no name a prefix of another, so a
    # `<name>-<slot>` config filename never aliases another env). `shortcode` is the 2-letter
    # tight-pattern env-segment, unique.
    $shortcodes = @()
    foreach ($env in $envKeys) {
        if ("$env" -cnotmatch '^[a-z][a-z0-9]+$') {
            $errors.Add("environment name '$env' is invalid (must be 2+ lowercase alphanumeric chars, leading letter)")
        }
        $entry = $Config.environments[$env]
        if (-not $entry.Contains('shortcode')) {
            $errors.Add("environment '$env' is missing 'shortcode'")
        }
        elseif ("$($entry.shortcode)" -cnotmatch '^[a-z]{2}$') {
            $errors.Add("environment '$env' has invalid shortcode '$($entry.shortcode)' (must be 2 lowercase letters)")
        }
        else {
            $shortcodes += "$($entry.shortcode)"
        }
        if (-not $entry.Contains('region')) {
            $errors.Add("environment '$env' is missing 'region'")
        }
        elseif ([string]::IsNullOrWhiteSpace($entry.region)) {
            $errors.Add("environment '$env' has empty 'region'")
        }
        if (-not $entry.Contains('region_code')) {
            $errors.Add("environment '$env' is missing 'region_code'")
        }
        elseif ("$($entry.region_code)" -cnotmatch '^[a-z]{3}$') {
            $errors.Add("environment '$env' has invalid region_code '$($entry.region_code)' (must be 3 lowercase letters, e.g. weu)")
        }
        # per_subscription (optional): marks an env as once-per-subscription (subn/subp). See data-model.md.
        if ($entry.Contains('per_subscription') -and $entry.per_subscription -isnot [bool]) {
            $errors.Add("environment '$env' has invalid per_subscription '$($entry.per_subscription)' (must be a boolean: true or false)")
        }
    }
    $dupeShort = $shortcodes | Group-Object | Where-Object Count -GT 1
    foreach ($d in $dupeShort) {
        $errors.Add("Duplicate environment shortcode: '$($d.Name)'")
    }
    # (No prefix-free constraint needed: a config file is `<name>[-<slot>].yml` and env names contain
    # no hyphen, so the name is the whole stem before the first `-` — never an ambiguous prefix.)

    # --- Subscriptions (map keyed by name) ---
    $subNames = @($Config.subscriptions.Keys)
    if ($subNames.Count -eq 0) {
        $errors.Add('subscriptions is empty')
    }
    foreach ($sName in $subNames) {
        $s = $Config.subscriptions[$sName]
        if ($sName -notmatch $identifierPattern) {
            $errors.Add("subscription name '$sName' is not a valid identifier (must match $identifierPattern)")
        }
        if (-not $s.Contains('id')) {
            $errors.Add("subscription '$sName' missing 'id'")
        }
        elseif (-not (Test-IsGuid $s.id)) {
            $errors.Add("subscription '$sName' has invalid id '$($s.id)' (must be a GUID)")
        }
        if (-not $s.Contains('tenant')) {
            $errors.Add("subscription '$sName' missing 'tenant'")
        }
        elseif ($s.tenant -notin $tenantNames) {
            $errors.Add("subscription '$sName' references unknown tenant '$($s.tenant)' (valid: $($tenantNames -join ', '))")
        }
        if (-not $s.Contains('environments')) {
            $errors.Add("subscription '$sName' missing 'environments'")
        }

        if ($s.Contains('environments')) {
            $envList = @($s.environments)
            if ($envList.Count -eq 0) {
                $errors.Add("subscription '$sName' has empty 'environments'")
            }
            foreach ($e in $envList) {
                if ($e -notin $envKeys) {
                    $errors.Add("subscription '$sName' references unknown environment '$e' (valid: $($envKeys -join ', '))")
                }
            }
        }
    }
    # (no duplicate-name check — map keys are unique by construction)

    # --- A subscription lists at most one per-subscription env (its identity env; "once per sub") ---
    $perSubEnvNames = @($envKeys | Where-Object {
            $pe = $Config.environments[$_]
            $pe.Contains('per_subscription') -and $pe['per_subscription']
        })
    foreach ($sName in $subNames) {
        $s = $Config.subscriptions[$sName]
        if ($s.Contains('environments')) {
            $subPerSub = @(@($s.environments) | Where-Object { $_ -in $perSubEnvNames })
            if ($subPerSub.Count -gt 1) {
                $errors.Add("subscription '$sName' lists more than one per-subscription environment ($($subPerSub -join ', ')) — at most one is allowed")
            }
        }
    }

    # --- Families (docs/adr/azure/data-model.md) ---
    # A subscription's family is derived: customer (raw token here — normalization is a cross-asset,
    # customer.yml read this hermetic validator must not make) -> explicit `family:` -> its own name.
    # The same derivation, normalized, is Get-AzureSubscriptionFamily; the shipped-asset integrity test
    # covers the normalized grouping.
    $familyMembers = @{}
    foreach ($sName in $subNames) {
        $s = $Config.subscriptions[$sName]
        if ($s.Contains('family')) {
            if ($s.Contains('customer')) {
                $errors.Add("subscription '$sName' declares both 'customer' and 'family' — a customer subscription's family IS its customer's key; remove 'family'")
            }
            if ("$($s.family)" -cnotmatch '^[a-z][a-z0-9]+$') {
                $errors.Add("subscription '$sName' has invalid family '$($s.family)' (must be 2+ lowercase alphanumeric chars, leading letter — the family is a configuration-folder name)")
            }
        }
        $family = if ($s.Contains('customer')) {
            "$($s.customer)"
        }
        elseif ($s.Contains('family')) {
            "$($s.family)"
        }
        else {
            $sName
        }
        if (-not $familyMembers.ContainsKey($family)) {
            $familyMembers[$family] = [System.Collections.Generic.List[string]]::new()
        }
        $familyMembers[$family].Add($sName)
    }

    # Within a family, no two members serve the same environment — the (family, env) -> subscription
    # join must resolve to exactly one member.
    foreach ($family in $familyMembers.Keys) {
        $members = @($familyMembers[$family])
        if ($members.Count -lt 2) {
            continue
        }
        $servedBy = @{}
        foreach ($sName in $members) {
            $s = $Config.subscriptions[$sName]
            if (-not $s.Contains('environments')) {
                continue
            }
            foreach ($e in @($s.environments)) {
                if ($servedBy.ContainsKey($e)) {
                    $errors.Add("family '$family' has more than one subscription serving environment '$e' ($($servedBy[$e]), $sName) — within a family every environment is served by exactly one subscription")
                }
                else {
                    $servedBy[$e] = $sName
                }
            }
        }
    }

    # Declared family configuration must configure a family that exists (>= 1 member) — no dead config.
    if ($Config.Contains('families')) {
        foreach ($family in @($Config.families.Keys)) {
            if ("$family" -cnotmatch '^[a-z][a-z0-9]+$') {
                $errors.Add("families entry '$family' is invalid (must be 2+ lowercase alphanumeric chars, leading letter)")
            }
            if (-not $familyMembers.ContainsKey("$family")) {
                $errors.Add("families entry '$family' has no member subscription — declare a member (customer key, `family:` key, or subscription name) or remove the entry")
            }
        }
    }

    if ($errors.Count -gt 0) {
        throw "azure configuration validation failed:`n$($errors -join "`n")"
    }
}
