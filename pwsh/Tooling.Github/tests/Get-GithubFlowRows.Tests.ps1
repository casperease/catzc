Describe 'Get-GithubFlowRows' -Tag 'L0', 'logic' {
    BeforeAll {
        # Neutral widget workflows in a fixture tree, never the real .github files.
        $script:root = Join-Path $TestDrive 'repo'
        $workflows = Join-Path $script:root '.github/workflows'
        $null = New-Item -ItemType Directory -Path $workflows -Force
        Set-Content -Path (Join-Path $workflows 'ci-widget.yml') -Value @(
            'name: CI', 'on:', '  push:', '    branches: [main]', '  pull_request:', '    branches: [main]', '  workflow_dispatch:',
            'jobs:', '  test:', '    runs-on: ubuntu-latest', '    steps:', '      - uses: actions/checkout@v4',
            '      - name: Run the widget tests', '        run: echo ok')
        Set-Content -Path (Join-Path $workflows 'gadget-release.yml') -Value @(
            'on:', '  workflow_dispatch:', 'jobs:', '  release:', '    environment: gadget-prod', '    runs-on: ubuntu-latest',
            '    steps:', '      - run: echo release')
        $script:point = '.github/workflows/ci-widget.yml;.github/workflows/gadget-release.yml'
    }

    BeforeEach {
        $script:row = Get-GithubFlowRows -Point $script:point -RepositoryRoot $script:root
        $script:lane = @{}
        foreach ($lane in $script:row.lanes) {
            $script:lane[$lane.id] = $lane
        }
    }

    It 'files one flow row under the point, a lane per workflow in the order given' {
        $script:row.lens | Should -Be 'flow'
        @($script:row.lanes.id) | Should -Be @('ci-widget', 'gadget-release')
        $script:lane['ci-widget'].engine | Should -Be 'github'
    }

    It 'reads the type from the file name''s prefix, and unknown for a name with none' {
        $script:lane['ci-widget'].type | Should -Be 'CI'
        $script:lane['gadget-release'].type | Should -Be 'unknown'
    }

    It 'reads the on: events as triggers, a pull request marking the lane for review' {
        $script:lane['ci-widget'].triggers | Should -Be @('push', 'pull request', 'manual')
        $script:lane['ci-widget'].review | Should -BeTrue
        $script:lane['gadget-release'].triggers | Should -Be @('manual')
    }

    It 'lists each job and its steps, a step by its name, else by what it uses' {
        @($script:lane['ci-widget'].templates.name) | Should -Be @('test', 'actions/checkout@v4', 'Run the widget tests')
        @($script:lane['ci-widget'].templates.kind) | Should -Be @('job', 'step', 'step')
    }

    It 'takes a job''s environment as the lane''s environment' {
        @($script:lane['gadget-release'].environments.id) | Should -Be @('gadget-prod')
    }
}
