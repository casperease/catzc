# catzc:
#   path: automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
#   module: Catzc.Azure.DevOps.BuildValidation
#   visibility: public

<#
.SYNOPSIS
    Registers (creates or updates) the build-validation branch policy tied to a globset. Idempotent.
.DESCRIPTION
    The existing policy is matched by pipeline plus branch, so a changed filter or name updates it in place.
    [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md),
    [ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4),
    [ADR-AUTO-IDEM](/docs/adr/automation/idempotent-state-functions.md)
    [comment:1](/docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md#comment1)
.PARAMETER GlobSet
    The declared globset the policy is tied to (a name in globs.yml).
.PARAMETER Pipeline
    Resolved in order: this parameter, the globset's build-validation.yml entry, then its globs.yml pipeline annotation.
    [comment:2](/docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md#comment2)
.PARAMETER Branch
    The branch the policy guards. Defaults from build-validation.yml 'branch'.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).
.PARAMETER DryRun
    The plan still reads the server and needs a registered pipeline; only the write is skipped.
    [comment:3](/docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md#comment3)
.EXAMPLE
    Register-AdoBuildValidation automation
.EXAMPLE
    Register-AdoBuildValidation nova -Branch main -DryRun
#>
function Register-AdoBuildValidation {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = '-Pipeline resolves from two sources keyed by -GlobSet (its build-validation.yml entry, then the globset annotation), and the body reads the same entry for -blocking; one lookup in the body beats a duplicated one in the declaration')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $GlobSet,

        [string] $Pipeline,

        [string] $Branch = (Get-Config -Config build-validation).branch,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [string] $RepositoryName = (Get-AdoRepositoryName),

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $GlobSet

    $set = Get-GlobSet -Name $GlobSet
    $config = Get-Config -Config build-validation
    $entry = @($config.validations) | Where-Object { "$($_.globset)" -eq $GlobSet } | Select-Object -First 1

    if (-not $Pipeline) {
        $Pipeline = if ($entry -and $entry.Contains('pipeline')) {
            $entry.pipeline
        }
        else {
            $set.Pipeline
        }
    }
    Assert-NotNullOrWhitespace $Pipeline -ErrorText "No pipeline for globset '$GlobSet'. Set -Pipeline, a 'pipeline' key on its build-validation.yml entry, or a 'pipeline' annotation on the globset."

    Assert-NotNullOrWhitespace $Branch -ErrorText 'Branch is required. Set -Branch or configure build-validation.yml.'

    $blocking = $true
    if ($entry -and $entry.Contains('blocking')) {
        $blocking = [bool]$entry.blocking
    }
    $displayName = if ($entry -and $entry.Contains('display_name')) {
        $entry.display_name
    }
    else {
        "Build validation - $GlobSet"
    }

    $context = Resolve-AdoBuildValidationContext -Project $Project -Organization $Organization -RepositoryName $RepositoryName

    $definitions = @(Get-AdoPipelineDefinitions -Project $context.Project -Organization $context.Organization)
    $definition = $definitions | Where-Object { $_.Name -eq $Pipeline } | Select-Object -First 1
    Assert-NotNull $definition -ErrorText "Pipeline '$Pipeline' is not registered in $($context.Organization)/$($context.Project). Run Register-AdoPipeline first."

    # Filter on the globset's native projection, the same globs the pipeline triggers on, never on a committed marker.
    # [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)
    # [comment:4](/docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md#comment4)
    $pathFilters = Get-BuildValidationPathFilter -GlobSet $set
    $desired = @{
        isEnabled  = $true
        isBlocking = $blocking
        type       = @{ id = $context.PolicyTypeId }
        settings   = @{
            buildDefinitionId       = $definition.Id
            displayName             = $displayName
            queueOnSourceUpdateOnly = $true
            manualQueueOnly         = $false
            validDuration           = 720
            filenamePatterns        = $pathFilters
            scope                   = @(
                @{ repositoryId = $context.RepositoryId; refName = "refs/heads/$Branch"; matchKind = 'Exact' }
            )
        }
    }

    $existingSet = @(Get-AdoBuildValidations -Branch $Branch -Project $context.Project -Organization $context.Organization -RepositoryName $context.RepositoryName)
    $existing = $existingSet | Where-Object { "$($_.PipelineDefinitionId)" -eq "$($definition.Id)" } | Select-Object -First 1

    $action = if (-not $existing) {
        'Create'
    }
    elseif ((@($existing.PathFilters) -join ',') -ne ($pathFilters -join ',') -or
        $existing.Blocking -ne $blocking -or
        $existing.DisplayName -ne $displayName -or
        -not $existing.Enabled) {
        'Update'
    }
    else {
        'Unchanged'
    }

    if ($DryRun) {
        $policyId = if ($existing) {
            $existing.Id
        }
        else {
            $null
        }
        return [pscustomobject]@{
            GlobSet    = $GlobSet
            Action     = $action
            Pipeline   = $Pipeline
            Branch     = $Branch
            PathFilter = $pathFilters
            Blocking   = $blocking
            PolicyId   = $policyId
        }
    }

    switch ($action) {
        'Create' {
            $ret = Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations?api-version=7.1" -Method Post -Body $desired
            Write-Message "Created build validation '$displayName' (id: $($ret.id)) for globset '$GlobSet' -> pipeline '$Pipeline' on $Branch"
        }
        'Update' {
            $ret = Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations/$($existing.Id)?api-version=7.1" -Method Put -Body $desired
            Write-Message "Updated build validation '$displayName' (id: $($existing.Id)) for globset '$GlobSet' -> pipeline '$Pipeline' on $Branch"
        }
        'Unchanged' {
            Write-Message "Build validation for globset '$GlobSet' is already current (id: $($existing.Id))"
            $ret = $existing.Raw
        }
    }
    $ret
}
