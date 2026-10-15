<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Read-BicepTemplateOptions.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
---
#>

<#
.SYNOPSIS
    Reads a template's optional `options.yml` and returns the validated deployment overrides.
.DESCRIPTION
    The schema is strict, so a typo in options.yml fails fast at discovery instead of silently doing nothing.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Read-BicepTemplateOptions.ps1.md#comment1)
.PARAMETER TemplateFolder
    Absolute path to the template folder (the one containing `main.bicep`).
.EXAMPLE
    Read-BicepTemplateOptions 'C:\repo\infrastructure\templates\sample-subscription'
    # -> [ordered]@{ deployment_target = 'Subscription' }
#>
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
    $allowedKeys = @('short_name', 'deployment_mode', 'deployment_target', 'environment_kind', 'customer_deployment')
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
