<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepParameterModel.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns a template's Bicep parameter model: every parameter its compiled main.json declares, with type,
    default, allowed values, and bounds.
.DESCRIPTION
    Edits to a reusable module under infrastructure/modules/ do not mark the build stale; rebuild by hand.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepParameterModel.ps1.md#comment1)
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.OUTPUTS
    [Catzc.Azure.Templates.BicepParameterModel]
.EXAMPLE
    (Get-BicepParameterModel foundation).Parameters.Values | Format-Table Name, Type, HasDefault, AllowedValues
#>
function Get-BicepParameterModel {
    [CmdletBinding()]
    [OutputType([Catzc.Azure.Templates.BicepParameterModel])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $mainJson = Join-Path $templateDescriptor.output_folder 'main.json'

    $inputFiles = @($templateDescriptor.bicep_files) + @($templateDescriptor.configuration_files)
    if ($null -ne $templateDescriptor.prepost_module) {
        $inputFiles += $templateDescriptor.prepost_module
    }
    $isCurrent = [System.IO.File]::Exists($mainJson)
    if ($isCurrent) {
        $builtAt = [System.IO.File]::GetLastWriteTimeUtc($mainJson)
        foreach ($inputFile in $inputFiles) {
            if ([System.IO.File]::GetLastWriteTimeUtc($inputFile) -gt $builtAt) {
                $isCurrent = $false
                break
            }
        }
    }
    if (-not $isCurrent) {
        Write-Message "No current build of template '$Template' — building it to read its parameter model"
        Build-Bicep $Template | Out-Null
    }

    Assert-PathExist $mainJson -PathType Leaf
    [Catzc.Azure.Templates.BicepParameterModel]::Parse($Template, [System.IO.File]::ReadAllText($mainJson))
}
