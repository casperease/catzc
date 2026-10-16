<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Set-AbandonedTestRun.Tests.ps1
    folder: tests
    name: set-abandoned-test-run-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Set-AbandonedTestRun' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates

        function script:New-WidgetRun {
            param([string] $Name, [System.Collections.IDictionary] $Manifest)
            $dir = Join-Path $script:root $Name
            [System.IO.Directory]::CreateDirectory($dir) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $dir 'run.json'), (ConvertTo-Json -InputObject $Manifest -Depth 4))
            $dir
        }

        function script:Read-WidgetRun {
            param([string] $Name)
            [System.IO.File]::ReadAllText((Join-Path $script:root "$Name/run.json")) | ConvertFrom-Json -AsHashtable
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:root) | Out-Null
    }

    It 'abandons a running run whose owner is gone, keeping the rest of its record' {
        New-WidgetRun 'widget-dead' ([ordered]@{ status = 'running'; startedAt = 'stamp-001'; ownerPid = [int]::MaxValue; ownerStart = 0 }) | Out-Null

        $marked = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Set-AbandonedTestRun -OutputFolder $Root }

        @($marked).Count | Should -Be 1
        $manifest = Read-WidgetRun 'widget-dead'
        $manifest.status | Should -Be 'abandoned'
        $manifest.startedAt | Should -Be 'stamp-001'
        $manifest.abandonedAt | Should -Not -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -match 'widget-dead abandoned .*\(PID \d+\) is gone' }
    }

    It 'writes a UTC start time back exactly as it was stamped, not in the local offset' {
        $startedAt = '2026-01-02T03:04:05.1234567+00:00'
        New-WidgetRun 'widget-utc' ([ordered]@{ status = 'running'; startedAt = $startedAt; ownerPid = [int]::MaxValue; ownerStart = 0 }) | Out-Null

        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Set-AbandonedTestRun -OutputFolder $Root } | Out-Null

        # The raw text, not a parsed value: ConvertFrom-Json would hide the offset the file actually carries.
        [System.IO.File]::ReadAllText((Join-Path $script:root 'widget-utc/run.json')) | Should -Match ([regex]::Escape("`"startedAt`": `"$startedAt`""))
    }

    It 'abandons a running run that names no owner' {
        New-WidgetRun 'widget-ownerless' ([ordered]@{ status = 'running' }) | Out-Null

        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Set-AbandonedTestRun -OutputFolder $Root } | Out-Null

        (Read-WidgetRun 'widget-ownerless').status | Should -Be 'abandoned'
    }

    It 'leaves a running run whose owner is alive untouched' {
        $ticks = [Catzc.Base.QualityGates.WorkerParentWatch]::CurrentStartTicks()
        New-WidgetRun 'widget-live' ([ordered]@{ status = 'running'; ownerPid = $PID; ownerStart = $ticks }) | Out-Null

        $marked = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Set-AbandonedTestRun -OutputFolder $Root }

        @($marked).Count | Should -Be 0
        (Read-WidgetRun 'widget-live').status | Should -Be 'running'
    }

    It 'leaves terminal runs untouched' {
        foreach ($status in 'passed', 'failed', 'crashed', 'abandoned') {
            New-WidgetRun "widget-$status" ([ordered]@{ status = $status; ownerPid = [int]::MaxValue; ownerStart = 0 }) | Out-Null
        }

        $marked = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Set-AbandonedTestRun -OutputFolder $Root }

        @($marked).Count | Should -Be 0
        foreach ($status in 'passed', 'failed', 'crashed', 'abandoned') {
            (Read-WidgetRun "widget-$status").status | Should -Be $status
        }
    }

    It 'skips an unparseable run.json and a folder with no run.json' {
        $broken = Join-Path $script:root 'widget-broken'
        [System.IO.Directory]::CreateDirectory($broken) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $broken 'run.json'), '{ not json')
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'widget-empty')) | Out-Null

        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Set-AbandonedTestRun -OutputFolder $Root } } | Should -Not -Throw
        [System.IO.File]::ReadAllText((Join-Path $broken 'run.json')) | Should -Be '{ not json'
    }

    It 'does nothing when the report folder does not exist' {
        $missing = Join-Path $script:root 'widget-missing'
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $missing } { param($Root) Set-AbandonedTestRun -OutputFolder $Root } } | Should -Not -Throw
    }
}
