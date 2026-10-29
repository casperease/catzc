Describe 'Save-AbandonedRunDurationHistory' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates

        function script:New-WidgetSidecar {
            param([string] $Run, [int] $Shard, [object[]] $Entry)
            [System.IO.Directory]::CreateDirectory($Run) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $Run "files-shard-$Shard.json"), (ConvertTo-Json -InputObject @($Entry) -Depth 2))
        }

        function script:Read-WidgetHistory {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:historyPath } { param($Path) Get-TestDurationHistory -Path $Path }
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:historyPath = Join-Path $script:root 'durations.json'
        $script:repositoryRoot = Join-Path $script:root 'repo'
        Mock Get-RepositoryRoot { $script:repositoryRoot } -ModuleName Catzc.Base.QualityGates
    }

    It 'records the files of every shard an abandoned run finished, keyed from the repository root' {
        $run = Join-Path $script:root 'widget-run'
        New-WidgetSidecar $run 0 @([pscustomobject]@{ File = (Join-Path $script:repositoryRoot 'widgets/W/tests/Widget.Tests.ps1'); DurationMs = 4200 })
        New-WidgetSidecar $run 7 @([pscustomobject]@{ File = (Join-Path $script:repositoryRoot 'widgets/W/tests/Gadget.Tests.ps1'); DurationMs = 87000 })

        InModuleScope Catzc.Base.QualityGates -Parameters @{ Run = $run; Path = $script:historyPath } {
            param($Run, $Path)
            Save-AbandonedRunDurationHistory -RunDirectory @($Run) -Path $Path
        }

        $history = Read-WidgetHistory
        $history['widgets/W/tests/Widget.Tests.ps1'] | Should -Be 4200
        $history['widgets/W/tests/Gadget.Tests.ps1'] | Should -Be 87000
    }

    It 'skips a bridged entry, a path outside the root and an unreadable sidecar' {
        $run = Join-Path $script:root 'widget-run'
        New-WidgetSidecar $run 0 @(
            [pscustomobject]@{ File = (Join-Path $script:repositoryRoot 'widgets/W/tests/Widget.Bridge.ps1'); DurationMs = 21000 },
            [pscustomobject]@{ File = (Join-Path $script:root 'snapshot/widgets/W/tests/Widget.Tests.ps1'); DurationMs = 5000 })
        [System.IO.File]::WriteAllText((Join-Path $run 'files-shard-1.json'), '{ not json')

        InModuleScope Catzc.Base.QualityGates -Parameters @{ Run = $run; Path = $script:historyPath } {
            param($Run, $Path)
            Save-AbandonedRunDurationHistory -RunDirectory @($Run) -Path $Path
        }

        [System.IO.File]::Exists($script:historyPath) | Should -BeFalse
    }

    It 'writes nothing for no abandoned run or a run folder that is gone' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Gone = (Join-Path $script:root 'gone'); Path = $script:historyPath } {
            param($Gone, $Path)
            Save-AbandonedRunDurationHistory -RunDirectory @() -Path $Path
            Save-AbandonedRunDurationHistory -RunDirectory @($Gone) -Path $Path
        }

        [System.IO.File]::Exists($script:historyPath) | Should -BeFalse
    }
}
