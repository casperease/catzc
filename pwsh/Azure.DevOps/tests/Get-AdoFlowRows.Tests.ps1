Describe 'Get-AdoFlowRows' -Tag 'L0', 'logic' {
    BeforeAll {
        # Neutral widget pipelines in a fixture tree, never the real .ado files.
        $script:root = Join-Path $TestDrive 'repo'
        $pipelines = Join-Path $script:root '.ado/pipelines'
        $null = New-Item -ItemType Directory -Path $pipelines -Force
        Set-Content -Path (Join-Path $pipelines 'ci-widget.yaml') -Value @(
            'trigger:', '  branches:', '    include: [main]', 'pr:', '  branches:', '    include: [main]',
            'stages:', '  - template: /.ado/pipelines/stages/build-widget.yaml')
        Set-Content -Path (Join-Path $pipelines 'cd-widget.yaml') -Value @(
            'trigger:', '  branches:', '    include: [main]', 'pr: none',
            'extends:', '  template: /.ado/pipelines/extends/cd-gadget.yaml')
        Set-Content -Path (Join-Path $pipelines 'deploy-widget.yaml') -Value @(
            'trigger: none', 'pr: none', 'stages:', '  - template: /.ado/pipelines/stages/deploy-unit.yaml')
        $script:point = '.ado/pipelines/ci-widget.yaml; .ado/pipelines/cd-widget.yaml;.ado/pipelines/deploy-widget.yaml'
    }

    BeforeEach {
        Mock Get-Rung -ModuleName Catzc.Azure.DevOps {
            [Catzc.Base.Flow.Rung]::new('main-uat', 'dev', 'none')
            [Catzc.Base.Flow.Rung]::new('release-uat', 'test', 'rc')
            [Catzc.Base.Flow.Rung]::new('prod', 'prod', 'prod-approval')
        }
        $script:row = Get-AdoFlowRows -Point $script:point -RepositoryRoot $script:root
        $script:lane = @{}
        foreach ($lane in $script:row.lanes) {
            $script:lane[$lane.id] = $lane
        }
    }

    It 'files one flow row under the point, a lane per pipeline file in the order given' {
        $script:row.lens | Should -Be 'flow'
        $script:row.point | Should -Be $script:point
        @($script:row.lanes.id) | Should -Be @('ci-widget', 'cd-widget', 'deploy-widget')
    }

    It 'reads each lane''s type and unit from its file name''s prefix' {
        $script:lane['ci-widget'].type | Should -Be 'CI'
        $script:lane['cd-widget'].type | Should -Be 'CD'
        $script:lane['deploy-widget'].type | Should -Be 'DEPLOY'
        $script:lane['deploy-widget'].unit | Should -Be 'widget'
    }

    It 'reads the triggers, a pull request marking the lane for review, and none at all as a manual run' {
        $script:lane['ci-widget'].triggers | Should -Be @('push', 'pull request')
        $script:lane['ci-widget'].review | Should -BeTrue
        $script:lane['cd-widget'].triggers | Should -Be @('push')
        $script:lane['deploy-widget'].triggers | Should -Be @('manual')
    }

    It 'names each template with the kind its folder gives' {
        $script:lane['ci-widget'].templates[0].kind | Should -Be 'stage'
        $script:lane['cd-widget'].templates[0].kind | Should -Be 'extends'
        $script:lane['cd-widget'].templates[0].name | Should -Be '.ado/pipelines/extends/cd-gadget.yaml'
    }

    It 'takes the environments from the rungs, the gated ones on the deploy lane marked for approval' {
        @($script:lane['cd-widget'].environments.id) | Should -Be @('widget-main-uat')
        @($script:lane['deploy-widget'].environments.id) | Should -Be @('widget-release-uat', 'widget-prod')
        @($script:lane['deploy-widget'].environments.approve) | Should -Be @($true, $true)
        $script:lane['cd-widget'].environments[0].approve | Should -BeFalse
    }

    It 'pins the deploy lane to its certifying cd lane by the shared unit name' {
        $script:row.edges | Should -HaveCount 1
        $script:row.edges[0].from | Should -Be 'deploy-widget'
        $script:row.edges[0].to | Should -Be 'cd-widget'
        $script:row.edges[0].label | Should -Be 'pins'
    }
}
