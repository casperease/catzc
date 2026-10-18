<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
    name: get-ado-build-validations
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps.BuildValidation
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: public
  edges:
    test: automation/Catzc.Azure.DevOps.BuildValidation/tests/Get-AdoBuildValidations.Tests.ps1
    cites:
      - ADR-FLOW-CD-GLOBS
      - ADR-FLOW-CD-TYPE#4
---
#>

function Get-AdoBuildValidations {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Branch,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [string] $RepositoryName = (Get-AdoRepositoryName)
    )

    $context = Resolve-AdoBuildValidationContext -Project $Project -Organization $Organization -RepositoryName $RepositoryName

    $configurations = @(Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations?api-version=7.1")

    foreach ($configuration in $configurations) {
        if ("$($configuration.type.id)" -ne $context.PolicyTypeId) {
            continue
        }
        $scopes = @($configuration.settings.scope)
        $matchingScope = $scopes | Where-Object { "$($_.repositoryId)" -eq "$($context.RepositoryId)" } | Select-Object -First 1
        if (-not $matchingScope) {
            continue
        }
        $scopeBranch = "$($matchingScope.refName)" -replace '^refs/heads/', ''
        if ($Branch -and $scopeBranch -ne $Branch) {
            continue
        }

        [pscustomobject]@{
            Id                   = $configuration.id
            DisplayName          = $configuration.settings.displayName
            PipelineDefinitionId = $configuration.settings.buildDefinitionId
            Branch               = $scopeBranch
            PathFilters          = @($configuration.settings.filenamePatterns)
            Blocking             = [bool]$configuration.isBlocking
            Enabled              = [bool]$configuration.isEnabled
            Raw                  = $configuration
        }
    }
}
