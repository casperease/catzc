<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1
    name: get-bicep-deployment-name
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
    page: docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
    test: automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentName.Tests.ps1
    cites:
      - ADR-FLOW-CD-DETECT#1
---
#>

function Get-BicepDeploymentName {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Position = 2)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Customer $fakeBoundParameters['Customer']
            })]
        [string] $Slot
    )

    $slotName = Get-BicepConfigName $Environment $Slot

    $buildId = 'xCLIxx'
    $commit = 'xxxxxxx'

    if (Test-IsRunningInPipeline) {
        if ($env:GITHUB_RUN_ID) {
            Assert-NotNullOrWhitespace $env:GITHUB_SHA
            $buildId = $env:GITHUB_RUN_ID
            $commit = $env:GITHUB_SHA.Substring(0, 7)
        }
        else {
            Assert-NotNullOrWhitespace $env:BUILD_BUILDID
            Assert-NotNullOrWhitespace $env:BUILD_SOURCEVERSION
            $buildId = $env:BUILD_BUILDID
            $commit = $env:BUILD_SOURCEVERSION.Substring(0, 7)
        }
    }

    $name = "$Template-$slotName-$buildId-$commit"

    Assert-True ($name.Length -gt 10) -ErrorText "Deployment name '$name' is too short"
    Assert-True ($name.Length -le 64) -ErrorText "Deployment name '$name' exceeds ARM's 64-char limit"

    $name
}
