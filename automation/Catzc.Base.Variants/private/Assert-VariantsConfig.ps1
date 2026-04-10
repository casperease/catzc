<#
.SYNOPSIS
    Validates configs/variants.yml and throws with all violations collected.
.DESCRIPTION
    Repo-wide variants — settings fixed for the importer session. A growing dictionary; today two keys:

      ado_naming:      standard | classic        — Azure resource-name component order
      have_customers:  false | all | [names]     — the enabled-customer set

    Integrity rules:
    - only the known keys are allowed (unknown key => throw), so a typo fails fast at load
    - ado_naming (if present) is 'standard' or 'classic' (the keys of Get-AzureNameOrderSet, mirrored here
      as literals because this Base validator must not depend up into the Azure/Templates layer)
    - have_customers (if present) is one of:
        * a boolean (false = disabled, true = every customer enabled)
        * the literal string 'all' (every customer enabled)
        * a list of customer-name tokens ('^[a-z][a-z0-9]+$', unique) — only those enabled
      An empty list is allowed and means disabled. It does NOT cross-check customer.yml (that catalogue
      lives one layer up, in Catzc.Azure); an Azure-layer integrity test confirms every listed name is a
      defined customer.

    Both keys are OPTIONAL in the file — the accessors default when a key is absent — but the shipped
    variants.yml sets both explicitly. Auto-dispatched by Get-Config when loading the 'variants' config.
#>
function Assert-VariantsConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    $errors = [System.Collections.Generic.List[string]]::new()

    $allowedKeys = @('ado_naming', 'have_customers')
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

    if ($errors.Count -gt 0) {
        throw "variants configuration validation failed:`n$($errors -join "`n")"
    }
}
