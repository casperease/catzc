# catzc:
#   path: automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1
#   module: Catzc.Azure.Templates
#   visibility: public

<#
.SYNOPSIS
    Builds an ARM deployment name for a bicep template.
.DESCRIPTION
    The subscription is not in the name: deployment names are scoped per subscription, so they cannot collide.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md#comment1)
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Environment name (selects the slot — its base slot when no -Slot).
.PARAMETER Slot
    Omitted selects the environment's base slot, the index-0 one.
    [comment:2](/docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md#comment2)
.EXAMPLE
    Get-BicepDeploymentName sample -Environment dev              # -> sample-dev-...
.EXAMPLE
    Get-BicepDeploymentName sample -Environment prod -Slot 001   # -> sample-prod-001-...
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
        # Only run-id and commit vars are read; TF_BUILD and GITHUB_ACTIONS are detection vars, off limits here.
        # [ADR-FLOW-CD-DETECT#1](/docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1)
        # [comment:3](/docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md#comment3)
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
