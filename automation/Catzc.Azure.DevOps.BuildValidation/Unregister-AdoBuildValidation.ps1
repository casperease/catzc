<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
    name: unregister-ado-build-validation
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
    test: automation/Catzc.Azure.DevOps.BuildValidation/tests/Unregister-AdoBuildValidation.Tests.ps1
    cites:
      - ADR-AUTO-IDEM#2
      - ADR-FLOW-CD-GLOBS
  config:
    synopsis: Removes the build-validation branch policy tied to a globset. Idempotent — a no-op when none exists.
    description: |-
      Finds the build-validation policy whose path filter is the globset's native projection
      (Get-GlobSetTrigger, [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md) — the tie between policy and globset)
      on the guarded branch and deletes
      it. When no such policy exists the function reports and returns without error
      ([ADR-AUTO-IDEM#2](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2)).
    parameters:
      GlobSet: The declared globset whose policy to remove (a name in globs.yml).
      Branch: The branch the policy guards. Defaults from build-validation.yml 'branch'.
      Project: Azure DevOps project name. Defaults to the value in ado.yml.
      Organization: Azure DevOps organization URL. Defaults to the value in ado.yml.
      RepositoryName: Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).
      DryRun: Return the planned removal (the matched policy id) without touching the server.
    examples:
      - Unregister-AdoBuildValidation nova
      - Unregister-AdoBuildValidation nova -DryRun
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
