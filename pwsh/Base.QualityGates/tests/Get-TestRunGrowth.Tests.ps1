Describe 'Get-TestRunGrowth' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-DEVBOXRUNBUDGET' {
    BeforeAll {
        $script:sourceContext = [ordered]@{ run = 'source'; selection = 'all tests'; tiersRunning = 'L0-L2' }

        # One run folder: its run.json and one files-shard sidecar of the given seconds per file.
        function New-Run {
            param([string] $Folder, [string] $Name, [string] $Status, [System.Collections.IDictionary] $Context, [hashtable] $Seconds, [double] $Duration = 100)
            $directory = Join-Path $Folder $Name
            [void][System.IO.Directory]::CreateDirectory($directory)
            $manifest = [ordered]@{ status = $Status; durationSeconds = $Duration; context = $Context }
            [System.IO.File]::WriteAllText((Join-Path $directory 'run.json'), (ConvertTo-Json -InputObject $manifest -Depth 4))
            if ($null -ne $Seconds) {
                $entries = @(foreach ($file in $Seconds.Keys) {
                        [ordered]@{ File = "C:\repo\pwsh\Widget\tests\$file"; DurationMs = $Seconds[$file] * 1000; Result = 'Passed'; ErrorMessage = '' }
                    })
                [System.IO.File]::WriteAllText((Join-Path $directory 'files-shard-0.json'), (ConvertTo-Json -InputObject $entries -Depth 2))
            }
            $directory
        }

        function New-File {
            param([hashtable] $Seconds, [string] $Root = 'C:\repo')
            @(foreach ($file in $Seconds.Keys) {
                    [pscustomobject]@{ File = "$Root\pwsh\Widget\tests\$file"; DurationMs = $Seconds[$file] * 1000 }
                })
        }

        function Get-Growth {
            param([string] $Folder, [string] $RunDirectory, [object[]] $File, [System.Collections.IDictionary] $Context = $script:sourceContext)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = $Folder; R = $RunDirectory; Files = $File; C = $Context } {
                param($F, $R, $Files, $C)
                Get-TestRunGrowth -OutputFolder $F -RunDirectory $R -File $Files -Context $C
            }
        }
    }

    BeforeEach {
        $script:folder = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:current = New-Run -Folder $script:folder -Name '20990102-000000' -Status 'running' -Context $script:sourceContext -Seconds $null
        $script:earlierSeconds = @{ 'Get-Widget.Tests.ps1' = 10; 'Get-Gadget.Tests.ps1' = 10; 'Set-Widget.Tests.ps1' = 10; 'Set-Gadget.Tests.ps1' = 10 }
    }

    It 'reads a growth spread over the files as spread, naming the earlier run and its top file' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Seconds $script:earlierSeconds -Duration 204.8 | Out-Null
        $file = New-File @{ 'Get-Widget.Tests.ps1' = 12.5; 'Get-Gadget.Tests.ps1' = 12; 'Set-Widget.Tests.ps1' = 12; 'Set-Gadget.Tests.ps1' = 12 }

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file

        $growth.Run | Should -Be '20990101-000000'
        $growth.Seconds | Should -Be 204.8
        $growth.GrowthSeconds | Should -Be 8.5
        $growth.TopFile | Should -Be 'Get-Widget.Tests.ps1'
        $growth.TopGrowthSeconds | Should -Be 2.5
        $growth.Spread | Should -BeTrue
    }

    It 'reads a third or more of the growth in one file as concentrated' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Seconds $script:earlierSeconds | Out-Null
        $file = New-File @{ 'Get-Widget.Tests.ps1' = 10; 'Get-Gadget.Tests.ps1' = 16; 'Set-Widget.Tests.ps1' = 11; 'Set-Gadget.Tests.ps1' = 10 }

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file

        $growth.TopFile | Should -Be 'Get-Gadget.Tests.ps1'
        $growth.TopGrowthSeconds | Should -Be 6
        $growth.GrowthSeconds | Should -Be 7
        $growth.Spread | Should -BeFalse
    }

    It 'compares with the newest earlier run of the same kind that passed, never the run itself' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Seconds $script:earlierSeconds -Duration 200 | Out-Null
        New-Run -Folder $script:folder -Name '20990101-010000' -Status 'failed' -Context $script:sourceContext -Seconds @{ 'Get-Widget.Tests.ps1' = 1 } | Out-Null
        $postBuild = [ordered]@{ run = 'source'; selection = 'post-build tests'; tiersRunning = 'L0-L2'; postBuild = $true }
        New-Run -Folder $script:folder -Name '20990101-020000' -Status 'passed' -Context $postBuild -Seconds @{ 'Get-Widget.Tests.ps1' = 1 } | Out-Null
        $modules = [ordered]@{ run = 'source'; selection = 'modules: TstWidget'; tiersRunning = 'L0-L2' }
        New-Run -Folder $script:folder -Name '20990101-030000' -Status 'passed' -Context $modules -Seconds @{ 'Get-Widget.Tests.ps1' = 1 } | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:current 'files-shard-0.json'), '[]')
        $file = New-File @{ 'Get-Widget.Tests.ps1' = 20 }

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file

        $growth.Run | Should -Be '20990101-000000'
        $growth.Seconds | Should -Be 200
    }

    It 'matches a file by its module, tests folder and name, so a snapshot run compares with an in-place one' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Seconds $script:earlierSeconds | Out-Null
        $file = New-File @{ 'Get-Widget.Tests.ps1' = 14 } -Root 'D:\sandbox\widget'

        (Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file).GrowthSeconds | Should -Be 4
    }

    It 'returns nothing when no earlier run of the kind passed' {
        $postBuild = [ordered]@{ run = 'source'; selection = 'post-build tests'; tiersRunning = 'L0-L2'; postBuild = $true }
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $postBuild -Seconds $script:earlierSeconds | Out-Null
        New-Run -Folder $script:folder -Name '20990101-010000' -Status 'failed' -Context $script:sourceContext -Seconds $script:earlierSeconds | Out-Null

        Get-Growth -Folder $script:folder -RunDirectory $script:current -File (New-File @{ 'Get-Widget.Tests.ps1' = 20 }) | Should -BeNullOrEmpty
    }

    It 'returns nothing when the earlier run holds no file records' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Seconds $null | Out-Null

        Get-Growth -Folder $script:folder -RunDirectory $script:current -File (New-File @{ 'Get-Widget.Tests.ps1' = 20 }) | Should -BeNullOrEmpty
    }

    It 'returns nothing when the files grew by nothing' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Seconds $script:earlierSeconds | Out-Null

        Get-Growth -Folder $script:folder -RunDirectory $script:current -File (New-File @{ 'Get-Widget.Tests.ps1' = 9 }) | Should -BeNullOrEmpty
    }

    It 'skips an unreadable run record and returns nothing for an unreadable file record, never throwing' {
        $broken = New-Run -Folder $script:folder -Name '20990101-010000' -Status 'passed' -Context $script:sourceContext -Seconds $null
        [System.IO.File]::WriteAllText((Join-Path $broken 'run.json'), '{ not json')
        $gadget = New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Seconds $null
        [System.IO.File]::WriteAllText((Join-Path $gadget 'files-shard-0.json'), '{ not json')

        Get-Growth -Folder $script:folder -RunDirectory $script:current -File (New-File @{ 'Get-Widget.Tests.ps1' = 20 }) | Should -BeNullOrEmpty
    }

    It 'returns nothing when the report folder does not exist' {
        Get-Growth -Folder (Join-Path $TestDrive 'missing') -RunDirectory $script:current -File (New-File @{ 'Get-Widget.Tests.ps1' = 20 }) |
            Should -BeNullOrEmpty
    }
}
