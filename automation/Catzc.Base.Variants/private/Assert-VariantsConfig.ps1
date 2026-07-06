<#
.SYNOPSIS
    Validates configs/variants.yml and throws with all violations collected.
.DESCRIPTION
    Repo-wide variants — settings fixed for the importer session. A growing dictionary; today three keys:

      ado_naming:      standard | classic        — Azure resource-name component order
      git_workspace:   main-direct | main-via-pr — how changes reach main (solo trunk vs everything-by-PR)
      have_customers:  false | all | [names]     — the enabled-customer set

    Integrity rules:
    - only the known keys are allowed (unknown key => throw), so a typo fails fast at load
    - ado_naming (if present) is 'standard' or 'classic' (the keys of Get-AzureNameOrderSet, mirrored here
      as literals because this Base validator must not depend up into the Azure/Templates layer)
    - git_workspace (if present) is 'main-direct' or 'main-via-pr'
    - have_customers (if present) is one of:
        * a boolean (false = disabled, true = every customer enabled)
        * the literal string 'all' (every customer enabled)
        * a list of customer-name tokens ('^[a-z][a-z0-9]+$', unique) — only those enabled
      An empty list is allowed and means disabled. It does NOT cross-check customer.yml (that catalogue
      lives one layer up, in Catzc.Azure); an Azure-layer integrity test confirms every listed name is a
      defined customer.

    Every key is OPTIONAL in the file — the accessors default when a key is absent — but the shipped
    variants.yml sets each explicitly. Auto-dispatched by Get-Config when loading the 'variants' config.
#>
function Assert-VariantsConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    $errors = [System.Collections.Generic.List[string]]::new()

    $allowedKeys = @('ado_naming', 'git_workspace', 'have_customers', 'aspects')
    foreach ($key in @($Config.Keys)) {
        if ($key -notin $allowedKeys) {
            $errors.Add("unknown key '$key' (allowed: $($allowedKeys -join ', '))")
        }
    }

    if ($Config.Contains('ado_naming')) {
        $validOrders = @('standard', 'classic')
        if ("$($Config.ado_naming)" -cnotmatch '^(standard|classic)$') {
            $errors.Add("invalid ado_naming '$($Config.ado_naming)' (valid: $($validOrders -join ', '))")
        }
    }

    if ($Config.Contains('git_workspace')) {
        $validModes = @('main-direct', 'main-via-pr')
        if ("$($Config.git_workspace)" -cnotmatch '^(main-direct|main-via-pr)$') {
            $errors.Add("invalid git_workspace '$($Config.git_workspace)' (valid: $($validModes -join ', '))")
        }
    }

    if ($Config.Contains('have_customers')) {
        $value = $Config.have_customers
        if ($value -is [bool]) {
            # boolean form — always valid (true = all, false = none)
        }
        elseif ($value -is [string]) {
            if ("$value" -cne 'all') {
                $errors.Add("invalid have_customers '$value' (a string must be 'all'; use a list for specific customers)")
            }
        }
        elseif ($value -is [System.Collections.IEnumerable]) {
            $names = @($value)
            $seen = @()
            foreach ($name in $names) {
                if ("$name" -cnotmatch '^[a-z][a-z0-9]+$') {
                    $errors.Add("invalid have_customers customer name '$name' (must be 2+ lowercase alphanumeric chars, leading letter)")
                }
                elseif ("$name" -in $seen) {
                    $errors.Add("duplicate have_customers customer name '$name'")
                }
                else {
                    $seen += "$name"
                }
            }
        }
        else {
            $errors.Add("invalid have_customers '$value' (must be false, 'all', or a list of customer names)")
        }
    }

    if ($Config.Contains('aspects')) {
        # An ordered first-match classification (ADR-ASPECT): a list of single-key {name: [patterns]} entries,
        # the LAST the '**' catch-all remainder, which by rule is non-live (a stray file must never ship). The
        # glob syntax of each pattern is validated downstream by the Globs aspect engine (no up-dependency here).
        $value = $Config.aspects
        if ($value -is [string] -or $value -isnot [System.Collections.IEnumerable]) {
            $errors.Add("invalid aspects (must be an ordered list of single-key {name: [patterns]} entries)")
        }
        else {
            $items = @($value)
            if ($items.Count -eq 0) {
                $errors.Add("aspects must list at least one aspect (the last is the '**' catch-all)")
            }
            $seen = @()
            for ($i = 0; $i -lt $items.Count; $i++) {
                $item = $items[$i]
                if ($item -isnot [System.Collections.IDictionary] -or @($item.Keys).Count -ne 1) {
                    $errors.Add("aspects[$i] must be a single-key mapping {name: [patterns]}")
                    continue
                }
                $name = "$(@($item.Keys)[0])"
                if ($name -cnotmatch '^[a-z][a-z0-9]*(-[a-z0-9]+)*$') {
                    $errors.Add("invalid aspect name '$name' (kebab-case)")
                }
                elseif ($name -in $seen) {
                    $errors.Add("duplicate aspect '$name'")
                }
                else {
                    $seen += $name
                }
                $patterns = @($item[@($item.Keys)[0]])
                if ($patterns.Count -eq 0 -or @($patterns | Where-Object { [string]::IsNullOrWhiteSpace("$_") }).Count -gt 0) {
                    $errors.Add("aspect '$name' needs at least one non-empty pattern")
                }
                $isLast = ($i -eq $items.Count - 1)
                if ($isLast) {
                    if (@($patterns).Count -ne 1 -or "$($patterns[0])" -ne '**') {
                        $errors.Add("the last aspect ('$name') must be the '**' catch-all remainder")
                    }
                    if ($name -ceq 'live') {
                        $errors.Add("the catch-all remainder aspect must be non-live (a stray file must never ship); declare 'live' earlier with explicit patterns")
                    }
                }
                elseif ($patterns -contains '**') {
                    $errors.Add("aspect '$name' uses the bare '**' catch-all but is not last — only the final aspect is the remainder; 'live' must stay a closed convention")
                }
            }
            if ('live' -notin $seen) {
                $errors.Add("aspects must include a 'live' aspect (the prod-going surface)")
            }
        }
    }

    if ($errors.Count -gt 0) {
        throw "variants configuration validation failed:`n$($errors -join "`n")"
    }
}
