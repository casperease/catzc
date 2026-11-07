Describe 'import ledger' -Tag 'L0', 'logic' {
    BeforeAll {
        $assets = Join-Path $PSScriptRoot '../assets/importer'
        . (Join-Path $assets 'ConvertTo-ImportLedgerLine.ps1')
        . (Join-Path $assets 'Add-ImportLedgerLine.ps1')
        . (Join-Path $assets 'Get-ImportCpuSuffix.ps1')
        . (Join-Path $assets 'Measure-ImportFileProbe.ps1')
        . (Join-Path $assets 'Write-ImportLedger.ps1')
    }

    Context 'Write-ImportLedger' {
        BeforeAll {
            $script:ledgerArgs = {
                param($root, $total)
                @{
                    RepositoryRoot = $root; ModulesRoot = (Join-Path $root 'widget-modules'); Started = [datetime]::UtcNow
                    TotalSeconds = $total; InitializerSeconds = 0.5; VendorSeconds = 0.2; LoopSeconds = 1.4; FinalizerSeconds = 0.3
                    CpuSeconds = 2.2; SinceProcessStartSeconds = 3.1; HostKind = 'console'
                }
            }
            $timeoutsFolder = Join-Path $TestDrive 'ledger/widget-modules/Base.Timeouts/configs'
            New-Item -ItemType Directory -Path $timeoutsFolder -Force | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $timeoutsFolder 'timeouts.yml'), "import:`n  console_seconds: 3`n")
        }

        It 'returns no suffix under the roof and appends one line' {
            $root = Join-Path $TestDrive 'ledger'
            $splat = & $script:ledgerArgs $root 2.4
            Write-ImportLedger @splat -TypesMs 500 -ParseCompileMs 900 -FileProbeMs 4 | Should -Be ''
            $row = [System.IO.File]::ReadAllLines((Join-Path $root 'out/import-times.jsonl'))[-1] | ConvertFrom-Json
            $row.typesSeconds | Should -Be 0.5
            $row.modulesSeconds | Should -Be 0.9
            $row.parseCompileMs | Should -Be 900
            $row.fileProbeMs | Should -Be 4
        }

        It 'returns the CPU suffix over the roof' {
            $splat = & $script:ledgerArgs (Join-Path $TestDrive 'ledger') 34.9
            Write-ImportLedger @splat | Should -Be ', 2.2 s of CPU'
        }

        It 'does not throw when the ledger cannot be written' {
            $root = Join-Path $TestDrive 'ledger-blocked'
            New-Item -ItemType Directory -Path $root | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $root 'out'), 'x')
            $splat = & $script:ledgerArgs $root 2.4
            { Write-ImportLedger @splat } | Should -Not -Throw
        }
    }

    Context 'Measure-ImportFileProbe' {
        It 'returns milliseconds for the first module folder, dot folders skipped' {
            $root = Join-Path $TestDrive 'probe'
            New-Item -ItemType Directory -Path (Join-Path $root '.hidden'), (Join-Path $root 'widget') -Force | Out-Null
            1..25 | ForEach-Object { [System.IO.File]::WriteAllText((Join-Path $root "widget/Get-Gadget$_.ps1"), 'function x {}') }
            Measure-ImportFileProbe -ModulesRoot $root | Should -BeOfType [int]
        }

        It 'returns null for a missing root' {
            Measure-ImportFileProbe -ModulesRoot (Join-Path $TestDrive 'nowhere') | Should -BeNullOrEmpty
        }
    }

    Context 'Get-ImportCpuSuffix' {
        It 'adds no CPU text under the roof' {
            Get-ImportCpuSuffix -TotalSeconds 2.4 -RoofSeconds 3 -CpuSeconds 2.1 | Should -Be ''
        }

        It 'adds the CPU text over the roof' {
            Get-ImportCpuSuffix -TotalSeconds 34.9 -RoofSeconds 3 -CpuSeconds 11.04 | Should -Be ', 11 s of CPU'
        }

        It 'adds no CPU text when the roof is unknown' {
            Get-ImportCpuSuffix -TotalSeconds 34.9 -RoofSeconds $null -CpuSeconds 11 | Should -Be ''
        }
    }

    Context 'ConvertTo-ImportLedgerLine' {
        It 'builds one compact JSON object with the phases, nulls kept' {
            $line = ConvertTo-ImportLedgerLine -Started ([datetime]::new(2026, 1, 2, 3, 4, 5, [System.DateTimeKind]::Utc)) -TotalSeconds 2.5 `
                -InitializerSeconds 0.5 -VendorSeconds 0.2 -ModulesSeconds 1.4 -FinalizerSeconds 0.3 `
                -CpuSeconds 2.2 -SinceProcessStartSeconds 3.1 -HostKind 'console'
            $line | Should -Not -Match "`n"
            $row = $line | ConvertFrom-Json
            $row.totalSeconds | Should -Be 2.5
            $row.modulesSeconds | Should -Be 1.4
            $row.hostKind | Should -Be 'console'
            $row.typesSeconds | Should -BeNullOrEmpty
            $row.fileReadMs | Should -BeNullOrEmpty
            $row.antivirusSignature | Should -BeNullOrEmpty
            $line | Should -BeLike '*"started":"2026-01-02T03:04:05*'
        }
    }

    Context 'Add-ImportLedgerLine' {
        It 'appends one line per call, creating the folder' {
            $path = Join-Path $TestDrive 'out/widget.jsonl'
            Add-ImportLedgerLine -Path $path -Line '{"a":1}'
            Add-ImportLedgerLine -Path $path -Line '{"a":2}'
            [System.IO.File]::ReadAllLines($path) | Should -Be @('{"a":1}', '{"a":2}')
        }

        It 'does not throw when the ledger cannot be written' {
            $blocker = Join-Path $TestDrive 'gadget'
            [System.IO.File]::WriteAllText($blocker, 'x')
            { Add-ImportLedgerLine -Path (Join-Path $blocker 'ledger.jsonl') -Line '{}' } | Should -Not -Throw
        }
    }
}
