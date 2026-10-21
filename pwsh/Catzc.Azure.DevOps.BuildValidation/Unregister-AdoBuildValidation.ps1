<#
---
catzc:
  immutable:
    with_body_sha: d882c1ec1cca
  edges:
    test: pwsh/Catzc.Azure.DevOps.BuildValidation/tests/Unregister-AdoBuildValidation.Tests.ps1
    docs: "[Unregister-AdoBuildValidation.ps1.md](docs/references/pwsh/catzc-azure-dev-ops-build-validation/Unregister-AdoBuildValidation.ps1.md)"
    cites:
      - ADR-AUTO-IDEM-ALREADYDONEISFINE
      - ADR-FLOW-CD-GLOBS
---
#>

function Unregister-AdoBuildValidation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $GlobSet,

        [string] $Branch = (Get-Config -Config build-validation).branch,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [string] $RepositoryName = (Get-AdoRepositoryName),

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $GlobSet

    $set = Get-GlobSet -Name $GlobSet
    Assert-NotNullOrWhitespace $Branch -ErrorText 'Branch is required. Set -Branch or configure build-validation.yml.'

    $context = Resolve-AdoBuildValidationContext -Project $Project -Organization $Organization -RepositoryName $RepositoryName

    $pathFilters = Get-BuildValidationPathFilter -GlobSet $set
    $expected = ($pathFilters -join ',')
    $validations = @(Get-AdoBuildValidations -Branch $Branch -Project $context.Project -Organization $context.Organization -RepositoryName $context.RepositoryName)
    $found = $validations | Where-Object { (@($_.PathFilters) -join ',') -eq $expected } | Select-Object -First 1

    if (-not $found) {
        Write-Message "No build validation tied to globset '$GlobSet' on $Branch - nothing to remove"
        return
    }

    if ($DryRun) {
        return [pscustomobject]@{
            GlobSet  = $GlobSet
            Action   = 'Remove'
            Branch   = $Branch
            PolicyId = $found.Id
        }
    }

    Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations/$($found.Id)?api-version=7.1" -Method Delete -UnwrapValue $false | Out-Null
    Write-Message "Removed build validation '$($found.DisplayName)' (id: $($found.Id)) for globset '$GlobSet' on $Branch"
}
