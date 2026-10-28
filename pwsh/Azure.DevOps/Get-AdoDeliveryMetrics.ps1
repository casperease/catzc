function Get-AdoDeliveryMetrics {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        # A deployable unit is one a deploy pipeline names, so the units are read from the deploy pipelines' file names.
        [string[]] $Unit = @(Get-ChildPath -Path (Join-Path $RepositoryRoot '.ado/pipelines') -Depth 1 -Filter 'deploy-*.yaml' -File | ForEach-Object {
                (Get-PipelineType ([System.IO.Path]::GetFileNameWithoutExtension($_))).Unit
            } | Sort-Object -Unique),

        [ValidateRange(1, 366)]
        [int] $Days = 30,

        [datetime] $Now = [datetime]::UtcNow,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [ValidateRange(1, 1000)]
        [int] $Top = 1000
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $apiBase = "$($Organization.TrimEnd('/'))/$Project/_apis"

    # Production is the last rung of the ladder, and its environment is named <unit>-<rung>.
    $production = @(Get-Rung)[-1].name
    $since = $Now.ToUniversalTime().AddDays(-$Days)

    $runs = @{}
    $getRun = {
        param([string] $RunId)
        if (-not $runs.ContainsKey($RunId)) {
            $runs[$RunId] = Invoke-AdoRestMethod -Uri "$apiBase/build/builds/$($RunId)?api-version=7.1" -UnwrapValue $false
        }
        $runs[$RunId]
    }
    $median = {
        param([double[]] $Values)
        if ($Values.Count -eq 0) {
            return $null
        }
        $sorted = @($Values | Sort-Object)
        $middle = [int][System.Math]::Floor($sorted.Count / 2)
        $value = if ($sorted.Count % 2) {
            $sorted[$middle]
        }
        else {
            ($sorted[$middle - 1] + $sorted[$middle]) / 2
        }
        [System.Math]::Round($value, 2)
    }

    foreach ($name in $Unit) {
        $environment = "$name-$production"
        $record = @(Invoke-AdoRestMethod -Uri "$apiBase/distributedtask/environments?name=$([uri]::EscapeDataString($environment))&api-version=7.1") |
            Where-Object { $null -ne $_ -and "$($_.name)" -eq $environment } | Select-Object -First 1
        $deployments = if ($record) {
            @(Invoke-AdoRestMethod -Uri "$apiBase/distributedtask/environments/$($record.id)/environmentdeploymentrecords?top=$Top&api-version=7.1") |
                Where-Object { $null -ne $_ -and $_.finishTime -and ([datetime] $_.finishTime).ToUniversalTime() -ge $since -and "$($_.result)" -in 'succeeded', 'failed' } |
                Sort-Object { ([datetime] $_.finishTime).ToUniversalTime() }
        }
        $deployments = @($deployments)
        $succeeded = @($deployments | Where-Object { "$($_.result)" -eq 'succeeded' })
        $failed = @($deployments | Where-Object { "$($_.result)" -eq 'failed' })

        # Lead time: from the deployed commit's commit time to the deployment's finish.
        $leadHours = [double[]] @(foreach ($deployment in $succeeded) {
                $commit = Resolve-AdoRunCommit -RunId "$($deployment.owner.id)" -GetRun $getRun
                if (-not $commit) {
                    continue
                }
                $shown = Invoke-Executable "git -C `"$RepositoryRoot`" show -s --format=%cI $commit" -PassThru -NoAssert -Silent
                if ($shown.ExitCode -ne 0 -or -not $shown.Output.Trim()) {
                    continue
                }
                (([datetime] $deployment.finishTime).ToUniversalTime() - ([datetimeoffset]::Parse($shown.Output.Trim())).UtcDateTime).TotalHours
            })
        # Recovery: from a failed deployment to the next successful one in the same environment.
        $recoveryHours = [double[]] @(foreach ($failure in $failed) {
                $failedAt = ([datetime] $failure.finishTime).ToUniversalTime()
                $next = $succeeded | Where-Object { ([datetime] $_.finishTime).ToUniversalTime() -gt $failedAt } | Select-Object -First 1
                if ($next) {
                    (([datetime] $next.finishTime).ToUniversalTime() - $failedAt).TotalHours
                }
            })

        [pscustomobject]@{
            Unit              = $name
            Environment       = $environment
            Days              = $Days
            Deployments       = $succeeded.Count
            DeploymentsPerDay = [System.Math]::Round($succeeded.Count / $Days, 2)
            LeadTimeHours     = & $median $leadHours
            ChangeFailRate    = if ($deployments.Count) {
                [System.Math]::Round($failed.Count / $deployments.Count, 2)
            }
            else {
                $null
            }
            RecoveryHours     = & $median $recoveryHours
        }
    }
}
