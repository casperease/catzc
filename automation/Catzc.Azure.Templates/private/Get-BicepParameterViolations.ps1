<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepParameterViolations.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns every violation of a template's rendered parameters files against its compiled parameter model.
.DESCRIPTION
    The rendered files hold the PrePost hook's merged values, so a hook-supplied parameter counts as supplied.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepParameterViolations.ps1.md#comment1)
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.OUTPUTS
    [string[]] the violations; empty when every rendered parameters file conforms.
#>
function Get-BicepParameterViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template
    )

    $model = Get-BicepParameterModel $Template
    $outputFolder = (Get-BicepTemplate $Template).output_folder

    $violations = [System.Collections.Generic.List[string]]::new()
    foreach ($parametersPath in @([System.IO.Directory]::EnumerateFiles($outputFolder, 'parameters.*.json') | Sort-Object)) {
        $label = "$Template/$([System.IO.Path]::GetFileName($parametersPath))"

        $document = $null
        try {
            $document = [System.Text.Json.JsonDocument]::Parse([System.IO.File]::ReadAllText($parametersPath))
        }
        catch {
            $violations.Add("${label}: is not valid JSON ($($_.Exception.Message))")
            continue
        }

        try {
            $section = [System.Text.Json.JsonElement]::new()
            $root = $document.RootElement
            $hasSection = $false
            if ($root.ValueKind -eq [System.Text.Json.JsonValueKind]::Object -and $root.TryGetProperty('parameters', [ref] $section)) {
                $hasSection = $section.ValueKind -eq [System.Text.Json.JsonValueKind]::Object
            }
            if (-not $hasSection) {
                $violations.Add("${label}: has no 'parameters' object")
                continue
            }

            $supplied = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($property in $section.EnumerateObject()) {
                $supplied.Add($property.Name) | Out-Null
                if (-not $model.Parameters.ContainsKey($property.Name)) {
                    $violations.Add("${label}: parameter '$($property.Name)' is not declared by the template's main.json")
                    continue
                }
                foreach ($violation in @(Get-BicepParameterEntryViolations -Parameter $model.Parameters[$property.Name] -Entry $property.Value)) {
                    $violations.Add("${label}: parameter '$($property.Name)' $violation")
                }
            }

            foreach ($parameter in @($model.Parameters.Values | Sort-Object Name)) {
                if ($parameter.IsRequired -and -not $supplied.Contains($parameter.Name)) {
                    $violations.Add("${label}: parameter '$($parameter.Name)' is required (main.json gives it no default) but is not supplied")
                }
            }
        }
        finally {
            $document.Dispose()
        }
    }

    $violations
}
