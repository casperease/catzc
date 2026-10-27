function Read-BicepTemplateOptions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $TemplateFolder
    )

    $optionsFile = Join-Path $TemplateFolder 'options.yml'
    if (-not (Test-Path $optionsFile -PathType Leaf)) {
        return [ordered]@{}
    }

    $options = Get-Content $optionsFile -Raw | ConvertFrom-Yaml -Ordered
    if ($null -eq $options) {
        # Empty or comment-only file — no overrides.
        return [ordered]@{}
    }

    $templateName = Split-Path $TemplateFolder -Leaf
    $allowedKeys = @('short_name', 'deployment_mode', 'deployment_target', 'environment_kind', 'customer_deployment', 'names', 'facts', 'addresses')
    $errors = [System.Collections.Generic.List[string]]::new()

    foreach ($key in @($options.Keys)) {
        if ($key -notin $allowedKeys) {
            $errors.Add("unknown key '$key' (allowed: $($allowedKeys -join ', '))")
        }
    }

    if ($options.Contains('deployment_mode')) {
        $validModes = Get-AzureBicepDeploymentModes
        if ($options.deployment_mode -notin $validModes) {
            $errors.Add("invalid deployment_mode '$($options.deployment_mode)' (valid: $($validModes -join ', '))")
        }
    }

    if ($options.Contains('deployment_target')) {
        $validTargets = Get-AzureBicepDeploymentTargets
        if ($options.deployment_target -notin $validTargets) {
            $errors.Add("invalid deployment_target '$($options.deployment_target)' (valid: $($validTargets -join ', '))")
        }
    }

    if ($options.Contains('short_name') -and "$($options.short_name)" -cnotmatch '^[a-z][a-z0-9]{1,4}$') {
        $errors.Add("invalid short_name '$($options.short_name)' (must be 2-5 lowercase alphanumeric chars starting with a letter)")
    }

    if ($options.Contains('environment_kind')) {
        $validKinds = Get-AzureBicepEnvironmentKinds
        if ($options.environment_kind -notin $validKinds) {
            $errors.Add("invalid environment_kind '$($options.environment_kind)' (valid: $($validKinds -join ', '))")
        }
    }

    # The entry shape is the BicepNameEntry type's to check; the namer's type set is read here, where the config is.
    if ($options.Contains('names') -and $options.names -is [System.Collections.IDictionary]) {
        $types = @((Get-AzureResourceTypeSet).Keys)
        foreach ($parameter in @($options.names.Keys)) {
            $entry = $options.names[$parameter]
            if ($entry -is [System.Collections.IDictionary] -and $entry.Contains('type') -and "$($entry.type)" -notin $types) {
                $errors.Add("names.${parameter}: unknown type '$($entry.type)' (valid: $($types -join ', '))")
            }
        }
    }

    if ($options.Contains('facts')) {
        if ($options.facts -isnot [System.Collections.IDictionary]) {
            $errors.Add('facts must be a map of slot parameter -> environment field')
        }
        else {
            $fields = @([Catzc.Azure.AzureEnvironmentRecord].GetProperties() | Where-Object PropertyType -EQ ([bool]) | ForEach-Object Name) + 'policy_enforcement', 'subscription_production'
            foreach ($parameter in @($options.facts.Keys)) {
                if ("$($options.facts[$parameter])" -cnotin $fields) {
                    $errors.Add("facts.${parameter}: unknown environment field '$($options.facts[$parameter])' (valid: $($fields -join ', '))")
                }
            }
        }
    }

    # A shared value every slot of the template takes, by its global config address, so no slot writes the same address line.
    if ($options.Contains('addresses')) {
        if ($options.addresses -isnot [System.Collections.IDictionary]) {
            $errors.Add('addresses must be a map of slot parameter -> global config address')
        }
        else {
            foreach ($parameter in @($options.addresses.Keys)) {
                if ("$($options.addresses[$parameter])" -cnotmatch '^global\.[A-Za-z0-9_-]+(\.[A-Za-z0-9_-]+)*$') {
                    $errors.Add("addresses.${parameter}: '$($options.addresses[$parameter])' is not a global config address (global.<config>.<key>...)")
                }
            }
        }
    }

    if ($options.Contains('customer_deployment') -and $options.customer_deployment -isnot [bool]) {
        $errors.Add("invalid customer_deployment '$($options.customer_deployment)' (must be a boolean: true or false)")
    }

    if ($errors.Count -gt 0) {
        throw "options.yml validation failed for template '$templateName':`n$($errors -join "`n")"
    }

    $ret = [ordered]@{}
    foreach ($key in $allowedKeys) {
        if ($options.Contains($key)) {
            $ret[$key] = $options[$key]
        }
    }
    $ret
}
