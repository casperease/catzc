Describe 'Get-AdoDeliveryMetrics' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:metrics = {
            param([hashtable] $Arguments)
            $Arguments.Organization = 'https://dev.azure.com/widgetorg'
            $Arguments.Project = 'Gadget'
            $Arguments.Now = [datetime]::new(2026, 3, 31, 0, 0, 0, [System.DateTimeKind]::Utc)
            $Arguments.RepositoryRoot = $TestDrive
            InModuleScope Catzc.Azure.DevOps -Parameters @{ A = $Arguments } { param($A) Get-AdoDeliveryMetrics @A }
        }
    }

    BeforeEach {
        # Runs 1 and 2 built commits aaa and bbb; the widget's production saw a failure on the 10th, recovered 6 hours later.
        $script:runs = @{
            '1' = [pscustomobject]@{ sourceVersion = 'aaa' }
            '2' = [pscustomobject]@{ sourceVersion = 'bbb' }
            '3' = [pscustomobject]@{ sourceVersion = 'ccc' }
        }
        $script:commitTimes = @{ aaa = '2026-03-01T10:00:00+00:00'; bbb = '2026-03-10T10:00:00+00:00' }
        $script:history = @(
            [pscustomobject]@{ owner = @{ id = 1 }; result = 'succeeded'; finishTime = '2026-03-01T14:00:00Z' }
            [pscustomobject]@{ owner = @{ id = 3 }; result = 'failed'; finishTime = '2026-03-10T12:00:00Z' }
            [pscustomobject]@{ owner = @{ id = 2 }; result = 'succeeded'; finishTime = '2026-03-10T18:00:00Z' }
            [pscustomobject]@{ owner = @{ id = 1 }; result = 'succeeded'; finishTime = '2026-01-01T00:00:00Z' }
            [pscustomobject]@{ owner = @{ id = 1 }; result = 'canceled'; finishTime = '2026-03-12T00:00:00Z' }
        )
        Mock Get-Rung -ModuleName Catzc.Azure.DevOps { [pscustomobject]@{ name = 'uat' }; [pscustomobject]@{ name = 'prod' } }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/build/builds/*' } {
            $script:runs[($Uri -split '/build/builds/')[1].Split('?')[0]]
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/distributedtask/environments?name=*' } {
            $name = [uri]::UnescapeDataString(($Uri -split 'name=')[1].Split('&')[0])
            if ($name -eq 'widget-prod') {
                [pscustomobject]@{ id = 7; name = $name }
            }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/environments/7/environmentdeploymentrecords*' } {
            $script:history
        }
        Mock Invoke-Executable -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Command -like '*show -s --format=%cI*' } {
            $commit = ($Command -split ' ')[-1]
            [Catzc.Base.Execution.CliResult]::new($script:commitTimes[$commit], '', [int](-not $script:commitTimes.ContainsKey($commit)))
        }
    }

    It 'reports the four metrics of a unit''s production environment over the window' {
        $result = & $script:metrics @{ Unit = @('widget'); Days = 30 }
        $result.Environment | Should -Be 'widget-prod'
        $result.Deployments | Should -Be 2
        $result.DeploymentsPerDay | Should -Be 0.07
        $result.LeadTimeHours | Should -Be 6
        $result.ChangeFailRate | Should -Be 0.33
        $result.RecoveryHours | Should -Be 6
    }

    It 'reports one record per unit, and empty metrics for a unit with no production environment' {
        $results = @(& $script:metrics @{ Unit = @('widget', 'gadget'); Days = 30 })
        $results.Unit | Should -Be @('widget', 'gadget')
        $gadget = $results | Where-Object Unit -EQ 'gadget'
        $gadget.Deployments | Should -Be 0
        $gadget.ChangeFailRate | Should -BeNullOrEmpty
        $gadget.LeadTimeHours | Should -BeNullOrEmpty
    }

    It 'reads the units from the deploy pipelines when none is named' {
        $pipelines = Join-Path $TestDrive '.ado/pipelines'
        $null = New-Item -ItemType Directory -Path $pipelines -Force
        Set-Content -LiteralPath (Join-Path $pipelines 'deploy-widget.yaml') -Value 'trigger: none'
        Set-Content -LiteralPath (Join-Path $pipelines 'ci-gadget.yaml') -Value 'trigger: none'
        (@(& $script:metrics @{ Days = 30 })).Unit | Should -Be @('widget')
    }
}
