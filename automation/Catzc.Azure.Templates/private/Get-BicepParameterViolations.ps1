<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/private/Get-BicepParameterViolations.ps1
    folder: private
    name: get-bicep-parameter-violations
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
  config:
    synopsis: Returns every violation of a template's rendered parameters files against its compiled parameter model.
    description: |-
      Reads the template's parameter model (Get-BicepParameterModel, which builds the template first when its output
      folder holds no current build) and checks every parameters.<config>.json that Build-Bicep rendered into the same
      output folder. The rendered files are the configs after the template's PrePost.psm1 prepare hook merged in its
      values, so a parameter the hook supplies counts as supplied. Per file it reports:
        - a parameter main.json does not declare;
        - a required parameter (no default, not nullable) that the file does not supply;
        - per supplied parameter, what Get-BicepParameterEntryViolations finds: a type mismatch, a value outside
          @allowed, a value or length out of bounds, a literal for a secure parameter, a malformed Key Vault reference.
      A file that is not a JSON object with a `parameters` object is one violation.

      Each message reads `<template>/<parameters file>: parameter '<name>' …` and never includes a secure
      parameter's value. Assert-BicepTemplate -Build reports these, and the L2 integrity test
      Get-BicepParameterModel.Shipped.Tests.ps1 asserts that no shipped template has any.
    parameters:
      Template: Template name (folder under infrastructure/templates/).
    outputs: '[string[]] the violations; empty when every rendered parameters file conforms.'
---
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
