<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps.BuildValidation/private/Resolve-AdoBuildValidationContext.ps1
    folder: private
    name: resolve-ado-build-validation-context
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.DevOps.BuildValidation
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: private
  config:
    synopsis: Resolves the ADO coordinates every build-validation call needs — org, project, repository id, API base.
    description: |-
      Defaults organization/project from ado.yml and the repository name from Get-AdoRepositoryName (the same
      default as Register-AdoPipeline and the public build-validation functions), resolves the
      repository to its GUID via the Git repositories API, and returns one context object the public
      functions share — including the well-known Build policy type id, so the constant lives in exactly one
      place.
    parameters:
      Project: Azure DevOps project name. Defaults to the value in ado.yml.
      Organization: Azure DevOps organization URL. Defaults to the value in ado.yml.
      RepositoryName: Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).
    examples:
      - '$context = Resolve-AdoBuildValidationContext'
---
#>

function Resolve-AdoBuildValidationContext {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [string] $RepositoryName = (Get-AdoRepositoryName)
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $Organization = $Organization.TrimEnd('/')

    Assert-NotNullOrWhitespace $RepositoryName -ErrorText 'RepositoryName is required. Set -RepositoryName, or run inside a checkout or a pipeline.'

    $apiBase = "$Organization/$Project/_apis"

    $repositories = @(Invoke-AdoRestMethod -Uri "$apiBase/git/repositories?api-version=7.1")
    $found = $repositories | Where-Object { $_.name -eq $RepositoryName } | Select-Object -First 1
    Assert-NotNull $found -ErrorText "Repository '$RepositoryName' not found in project '$Project'"

    @{
        Organization   = $Organization
        Project        = $Project
        ApiBase        = $apiBase
        RepositoryName = $RepositoryName
        RepositoryId   = $found.id
        # The well-known ADO 'Build' policy type — the discriminator every build-validation policy carries.
        PolicyTypeId   = '0609b952-1397-4640-95ec-e00a01b2c241'
    }
}
