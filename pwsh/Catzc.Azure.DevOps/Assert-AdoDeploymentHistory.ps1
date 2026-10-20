function Assert-AdoDeploymentHistory {
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
