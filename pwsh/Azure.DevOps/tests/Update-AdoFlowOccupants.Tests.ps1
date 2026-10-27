Describe 'Update-AdoFlowOccupants' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:update = {
            param([string] $Path)
            InModuleScope Catzc.Azure.DevOps -Parameters @{ P = $Path } {
                param($P)
                Update-AdoFlowOccupants $P -Organization 'https://dev.azure.com/widgetorg' -Project 'Gadget' -RepositoryRoot $TestDrive
            }
        }
    }

    BeforeEach {
        $script:path = Join-Path $TestDrive 'widget-flow.drawio.yml'
        Set-Content -LiteralPath $script:path -Value @(
            'about:'
            '  lens: flow'
            '  point: .ado/pipelines/cd-widget.yaml;.ado/pipelines/deploy-widget.yaml'
            '  occupants:'
            '    widget-old: stale'
            'content:'
            '  title: A widget flows'
        )
        # Run 10 built commit aaa; run 20 is a DEPLOY run naming CI run 10, and run 30 a CD run of its own commit bbb.
        $script:runs = @{
            '10' = [pscustomobject]@{ sourceVersion = 'aaa' }
            '20' = [pscustomobject]@{ sourceVersion = 'main-head'; templateParameters = [pscustomobject]@{ CiRunId = '10' } }
            '30' = [pscustomobject]@{ sourceVersion = 'bbb' }
        }
        $script:environments = @{ 'widget-uat' = 41; 'widget-prod' = 42 }
        $script:history = @{
            41 = @([pscustomobject]@{ owner = @{ id = 30 }; result = 'succeeded' })
            42 = @(
                [pscustomobject]@{ owner = @{ id = 30 }; result = 'failed' }
                [pscustomobject]@{ owner = @{ id = 20 }; result = 'succeeded' }
            )
        }
        Mock Get-AdoFlowRows -ModuleName Catzc.Azure.DevOps {
            [ordered]@{ lanes = @(
                    [ordered]@{ environments = @([ordered]@{ id = 'widget-uat' }) }
                    [ordered]@{ environments = @([ordered]@{ id = 'widget-prod' }, [ordered]@{ id = 'widget-gone' }) }
                )
            }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/build/builds/*' } {
            $script:runs[($Uri -split '/build/builds/')[1].Split('?')[0]]
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/distributedtask/environments?name=*' } {
            $name = [uri]::UnescapeDataString(($Uri -split 'name=')[1].Split('&')[0])
            if ($script:environments.ContainsKey($name)) {
                [pscustomobject]@{ id = $script:environments[$name]; name = $name }
            }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/environmentdeploymentrecords*' } {
            $script:history[[int]($Uri -split '/environments/')[1].Split('/')[0]]
        }
    }

    It 'writes each environment''s latest successful deployment commit into about.occupants, replacing the old map' {
        $occupants = & $script:update $script:path
        $occupants['widget-uat'] | Should -Be 'bbb'
        $occupants['widget-prod'] | Should -Be 'aaa'
        $occupants.Contains('widget-gone') | Should -BeFalse
        Get-Content -LiteralPath $script:path | Should -Be @(
            'about:'
            '  lens: flow'
            '  point: .ado/pipelines/cd-widget.yaml;.ado/pipelines/deploy-widget.yaml'
            '  occupants:'
            '    widget-uat: bbb'
            '    widget-prod: aaa'
            'content:'
            '  title: A widget flows'
        )
        Should -Invoke Get-AdoFlowRows -ModuleName Catzc.Azure.DevOps -Times 1 -Exactly -ParameterFilter {
            $Point -eq '.ado/pipelines/cd-widget.yaml;.ado/pipelines/deploy-widget.yaml'
        }
    }

    It 'drops the map when no environment holds a deployment' {
        $script:history = @{ 41 = @(); 42 = @() }
        $null = & $script:update $script:path
        Get-Content -LiteralPath $script:path | Should -Not -Contain '  occupants:'
    }

    It 'throws when the declaration names no point' {
        Set-Content -LiteralPath $script:path -Value @('about:', '  lens: flow', 'content:', '  title: A widget')
        { & $script:update $script:path } | Should -Throw '*has no about.point*'
    }
}
