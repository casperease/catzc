<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/Get-BicepParameterModel.ps1
    name: get-bicep-parameter-model
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
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
