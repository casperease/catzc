function Register-AdoBuildValidation {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '',
        Justification = '-Pipeline resolves from two sources keyed by -GlobSet (its build-validation.yml entry, then the globset annotation), and the body reads the same entry for -blocking; one lookup in the body beats a duplicated one in the declaration')]
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

    # The policy filters on the same globs the pipeline triggers on, never a committed marker.
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
    $existing = $existingSet | Where-Object { "$($_.PipelineDefinitionId)" -eq "$($definition.Id)" } |
        Select-Object -First 1

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
