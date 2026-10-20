function Assert-AdoDeploymentHistory {
    <#
    .SYNOPSIS
    Throws unless an Azure DevOps environment's deployment history holds a successful deployment of a CI run's commit.

    .DESCRIPTION
    The certifying record of a rung is the deployment history of its environment
    ([ADR-FLOW-CD-CERTIFYINGRECORD](/docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-certifyingrecord)): a DEPLOY run to a
    prod target calls this before it deploys, so a commit that never stood on pre-prod cannot ship. The commit is the source commit of the CI
    run that built the artifact. Each successful deployment in the history names the run that made it; that run's commit is the source commit
    of the CI run its `CiRunId` parameter names, or its own source commit when it has none. The newest matching deployment is returned; no
    match throws, naming the commit and the environment.

    .PARAMETER Environment
    The Azure DevOps environment whose history certifies the commit, e.g. `<unit>-pre-prod`.

    .PARAMETER CiRunId
    The run id of the CI run that built the artifact being deployed.

    .PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.

    .PARAMETER Organization
    Azure DevOps organization URL (`https://dev.azure.com/<org>`). Defaults to the value in ado.yml.

    .PARAMETER Top
    How many of the newest deployments to read from the history.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Environment,

        [Parameter(Mandatory)]
        [int] $CiRunId,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [ValidateRange(1, 1000)]
        [int] $Top = 100
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $apiBase = "$($Organization.TrimEnd('/'))/$Project/_apis"

    $runs = @{}
    $getRun = {
        param([string] $RunId)
        if (-not $runs.ContainsKey($RunId)) {
            $runs[$RunId] = Invoke-AdoRestMethod -Uri "$apiBase/build/builds/$($RunId)?api-version=7.1" -UnwrapValue $false
        }
        $runs[$RunId]
    }

    $commit = "$((& $getRun "$CiRunId").sourceVersion)"
    Assert-NotNullOrWhitespace $commit -ErrorText "CI run $CiRunId has no source commit in $Organization/$Project."

    $record = @(Invoke-AdoRestMethod -Uri "$apiBase/distributedtask/environments?name=$([uri]::EscapeDataString($Environment))&api-version=7.1") |
        Where-Object { $null -ne $_ -and "$($_.name)" -eq $Environment } | Select-Object -First 1
    Assert-NotNull $record -ErrorText "Environment '$Environment' does not exist in $Organization/$Project, so it certifies nothing."

    $deployments = @(Invoke-AdoRestMethod -Uri "$apiBase/distributedtask/environments/$($record.id)/environmentdeploymentrecords?top=$Top&api-version=7.1") |
        Where-Object { $null -ne $_ -and "$($_.result)" -eq 'succeeded' }

    foreach ($deployment in $deployments) {
        $run = & $getRun "$($deployment.owner.id)"
        $parameters = if ($run.PSObject.Properties['templateParameters']) {
            $run.templateParameters
        }
        $source = if ($parameters -and $parameters.PSObject.Properties['CiRunId'] -and "$($parameters.CiRunId)") {
            & $getRun "$($parameters.CiRunId)"
        }
        else {
            $run
        }
        if ("$($source.sourceVersion)" -eq $commit) {
            Write-Message "Commit $commit is certified by '$Environment': run $($deployment.owner.id) deployed it there."
            return [pscustomobject]@{
                Environment = $Environment
                Commit      = $commit
                RunId       = "$($deployment.owner.id)"
            }
        }
    }

    throw "Commit $commit (CI run $CiRunId) has no successful deployment in the last $Top of '$Environment', so it never stood on that rung " +
    '(ADR-FLOW-CD-CERTIFYINGRECORD).'
}
