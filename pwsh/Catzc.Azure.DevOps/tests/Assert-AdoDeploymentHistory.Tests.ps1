Describe 'Assert-AdoDeploymentHistory' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:assert = {
            param([hashtable] $Arguments)
            $Arguments.Organization = 'https://dev.azure.com/widgetorg'
            $Arguments.Project = 'Gadget'
            InModuleScope Catzc.Azure.DevOps -Parameters @{ A = $Arguments } { param($A) Assert-AdoDeploymentHistory @A }
        }
    }

    BeforeEach {
        # Run 10 is the CI run that built commit aaa; run 11 built bbb. Runs 20 and 21 are DEPLOY runs naming a CI run;
        # run 30 is a CD run.
        $script:runs = @{
            '10' = [pscustomobject]@{ sourceVersion = 'aaa' }
            '11' = [pscustomobject]@{ sourceVersion = 'bbb' }
            '20' = [pscustomobject]@{ sourceVersion = 'main-head'; templateParameters = [pscustomobject]@{ CiRunId = '11' } }
            '21' = [pscustomobject]@{ sourceVersion = 'main-head'; templateParameters = [pscustomobject]@{ CiRunId = '10' } }
            '30' = [pscustomobject]@{ sourceVersion = 'aaa' }
        }
        $script:history = @()
        Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/build/builds/*' } {
            $script:runs[($Uri -split '/build/builds/')[1].Split('?')[0]]
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/distributedtask/environments?name=*' } {
            [pscustomobject]@{ id = 42; name = [uri]::UnescapeDataString(($Uri -split 'name=')[1].Split('&')[0]) }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/environments/42/environmentdeploymentrecords*' } {
            $script:history
        }
    }

    It 'stops a commit absent from the pre-prod history' {
        $script:history = @([pscustomobject]@{ owner = @{ id = 20 }; result = 'succeeded' })
        { & $script:assert @{ Environment = 'widget-pre-prod'; CiRunId = 10 } } |
            Should -Throw '*Commit aaa (CI run 10) has no successful deployment*widget-pre-prod*'
    }

    It 'stops a commit whose only pre-prod deployment failed' {
        $script:history = @([pscustomobject]@{ owner = @{ id = 21 }; result = 'failed' })
        { & $script:assert @{ Environment = 'widget-pre-prod'; CiRunId = 10 } } |
            Should -Throw '*has no successful deployment*'
    }

    It 'passes a commit a DEPLOY run put on pre-prod, through the CI run it names' {
        $script:history = @(
            [pscustomobject]@{ owner = @{ id = 20 }; result = 'succeeded' }
            [pscustomobject]@{ owner = @{ id = 21 }; result = 'succeeded' }
        )
        $result = & $script:assert @{ Environment = 'widget-pre-prod'; CiRunId = 10 }
        $result.Commit | Should -Be 'aaa'
        $result.RunId | Should -Be '21'
    }

    It 'passes a commit a run without a CiRunId deployed, by its own source commit' {
        $script:history = @([pscustomobject]@{ owner = @{ id = 30 }; result = 'succeeded' })
        (& $script:assert @{ Environment = 'widget-pre-prod'; CiRunId = 10 }).RunId | Should -Be '30'
    }

    It 'throws when the environment does not exist' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/distributedtask/environments?name=*' } { @() }
        { & $script:assert @{ Environment = 'widget-pre-prod'; CiRunId = 10 } } |
            Should -Throw "*Environment 'widget-pre-prod' does not exist*"
    }
}
