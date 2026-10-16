<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepParameterModel.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
  config:
    synopsis: |-
      Returns a template's Bicep parameter model: every parameter its compiled main.json declares, with type,
      default, allowed values, and bounds.
    description: |-
      Reads the `parameters` section of the main.json that Build-Bicep writes to the template's output folder
      (Get-BicepTemplatesOutputRoot) and returns it as a [Catzc.Azure.Templates.BicepParameterModel]: the template
      name plus one [Catzc.Azure.Templates.BicepParameter] per declared parameter, keyed by name.

      When the output folder holds no current build, it runs Build-Bicep first, which also renders the
      parameters.<config>.json files. A build is current when its main.json is at least as new as every input
      Build-Bicep reads from the template folder: the template's *.bicep files, its configuration files, and its
      PrePost.psm1. A reusable module under infrastructure/modules/ is not among those inputs, so after editing
      only a module run Build-Bicep yourself. The build is the only call to `az`; reading the model is pure over
      the JSON.

      Get-BicepParameterViolations checks every rendered parameters file against this model.
    parameters:
      Template: Template name (folder under infrastructure/templates/).
    outputs: '[Catzc.Azure.Templates.BicepParameterModel]'
    examples:
      - (Get-BicepParameterModel foundation).Parameters.Values | Format-Table Name, Type, HasDefault, AllowedValues
---
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
