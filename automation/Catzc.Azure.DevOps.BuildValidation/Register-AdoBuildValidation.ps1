<#
.SYNOPSIS
    Registers (creates or updates) the build-validation branch policy tied to a globset. Idempotent.
.DESCRIPTION
    Binds the globset's native path projection (Get-GlobSetTrigger, ADR-GLOBS) as the path filter of an
    ADO build-validation policy that queues the resolved pipeline on the guarded branch — the server-side
    pre-commit half of the unit's CI binding (ADR-PIPETYPE:4). Everything defaults from local config: the
    pipeline resolves -Pipeline, then the globset's build-validation.yml entry, then the globset's own
    'pipeline:' annotation in globs.yml; the branch resolves -Branch, then build-validation.yml 'branch';
    blocking and the display name come from the entry (defaults: blocking, 'Build validation - <globset>').

    Idempotent (ADR-IDEM): an existing policy for the same pipeline on the same branch is updated when it
    differs and left alone when current; the resulting policy configuration is returned either way. The
    matching existing policy is found by pipeline definition + branch, so a marker-path or display-name
    change updates the policy in place instead of creating a duplicate.
.PARAMETER GlobSet
    The declared globset the policy is tied to (a name in globs.yml).
.PARAMETER Pipeline
    The pipeline (build definition) name to queue. Defaults from the globset's build-validation.yml entry,
    then its globs.yml 'pipeline:' annotation.
.PARAMETER Branch
    The branch the policy guards. Defaults from build-validation.yml 'branch'.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to $env:BUILD_REPOSITORY_NAME or the leaf folder of
    $env:RepositoryRoot.
.PARAMETER DryRun
    Return the planned action (Create/Update/Unchanged with the resolved pipeline, branch, and path
    filter) without touching the server.
.EXAMPLE
    Register-AdoBuildValidation automation
.EXAMPLE
    Register-AdoBuildValidation nova -Branch main -DryRun
#>
function Register-AdoBuildValidation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $GlobSet,

        [string] $Pipeline,

        [string] $Branch,

        [string] $Project,

        [string] $Organization,

        [string] $RepositoryName,

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

    if (-not $Branch) {
        $Branch = $config.branch
    }
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

    # The server-side pre-commit trigger filters on the globset's native path projection
    # (Get-BuildValidationPathFilter -> Get-GlobSetTrigger, ADR-GLOBS) — the same globs the pipeline
    # triggers on — never a committed marker.
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
