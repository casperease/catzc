<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.Templates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
      test: automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentName.Tests.ps1
    adrs:
      - ADR-FLOW-CD-DETECT#1
  config:
    synopsis: Builds an ARM deployment name for a bicep template.
    description: |-
      Pattern: `<Template>-<slotName>-<buildId>-<commit>`, where slotName is the slot (the env's
      `<env>` or `<env>-<slot>`) — so two slots of one template never collide on a name. The subscription
      is NOT in the name: deployment names are scoped per subscription (group create --subscription / sub
      create), so the same name in two subscriptions never collides.

      On a pipeline agent (Test-IsRunningInPipeline → $true), the buildId and commit are read from the host
      CI's env vars — Azure DevOps (`BUILD_BUILDID` / `BUILD_SOURCEVERSION`) or GitHub Actions
      (`GITHUB_RUN_ID` / `GITHUB_SHA`); the commit is truncated to 7 chars.

      On a devbox, placeholders ('xCLIxx' / 'xxxxxxx') are used — devbox deploys are dev-only
      iterations and we deliberately avoid coupling to git here.

      Asserts the result is 11..64 chars (ARM's 64-char deployment-name limit).
    parameters:
      Template: Template name (folder under infrastructure/templates/).
      Environment: Environment name (selects the slot — its base slot when no -Slot).
      Slot: |-
        Optional special-slot discriminator (1-3 lowercase alphanumeric chars, `001`). Omitted selects the
        env's base / index-0 slot.
    examples:
      - 'Get-BicepDeploymentName sample -Environment dev              # -> sample-dev-...'
      - 'Get-BicepDeploymentName sample -Environment prod -Slot 001   # -> sample-prod-001-...'
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
