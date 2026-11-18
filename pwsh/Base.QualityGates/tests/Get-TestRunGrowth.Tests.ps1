Describe 'Get-TestRunGrowth' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-DEVBOXRUNBUDGET' {
    BeforeAll {
        $script:sourceContext = [ordered]@{ run = 'source'; selection = 'all tests'; tiersRunning = 'L0-L2' }

        # The rows of one shard: the given seconds per widget test file.
        function New-Row {
            param([hashtable] $Seconds, [string] $Root = 'C:\repo')
            @(foreach ($file in $Seconds.Keys) {
                    [pscustomobject]@{ File = "$Root\gadgets\Widget\tests\$file"; DurationMs = $Seconds[$file] * 1000; Result = 'Passed'; ErrorMessage = '' }
                })
        }

        # One run folder: its run.json naming one shard, and that shard's files sidecar; -Incomplete records one file more than the sidecar holds.
        function New-Run {
            param([string] $Folder, [string] $Name, [string] $Status, [System.Collections.IDictionary] $Context, [object[]] $Row, [double] $Duration = 100,
                [switch] $Incomplete)
            $directory = Join-Path $Folder $Name
            [void][System.IO.Directory]::CreateDirectory($directory)
            $rows = @($Row)
            $shards = @(if ($rows.Count -gt 0) {
                    [ordered]@{ label = 'shard-0'; files = $rows.Count + [int] [bool] $Incomplete }
                })
            $manifest = [ordered]@{ status = $Status; durationSeconds = $Duration; context = $Context; shards = $shards }
            [System.IO.File]::WriteAllText((Join-Path $directory 'run.json'), (ConvertTo-Json -InputObject $manifest -Depth 4))
            if ($rows.Count -gt 0) {
                [System.IO.File]::WriteAllText((Join-Path $directory 'files-shard-0.json'), (ConvertTo-Json -InputObject $rows -Depth 2))
            }
            $directory
        }

        function Get-Growth {
            param([string] $Folder, [string] $RunDirectory, [object[]] $File, [System.Collections.IDictionary] $Context = $script:sourceContext)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = $Folder; R = $RunDirectory; Files = $File; C = $Context } {
                param($F, $R, $Files, $C)
                Get-TestRunGrowth -OutputFolder $F -RunDirectory $R -File $Files -Context $C -RepositoryRoot 'C:\repo'
            }
        }
    }

    BeforeEach {
        $script:folder = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:current = New-Run -Folder $script:folder -Name '20990102-000000' -Status 'running' -Context $script:sourceContext -Row @()
        $script:earlierRow = New-Row @{ 'Get-Widget.Tests.ps1' = 10; 'Get-Gadget.Tests.ps1' = 10; 'Set-Widget.Tests.ps1' = 10; 'Set-Gadget.Tests.ps1' = 10 }
    }

    It 'reads growth whose top file holds under half as spread, counting the files grown by two seconds or more' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row $script:earlierRow -Duration 204.8 | Out-Null
        $file = New-Row @{ 'Get-Widget.Tests.ps1' = 13; 'Get-Gadget.Tests.ps1' = 12.5; 'Set-Widget.Tests.ps1' = 12.5; 'Set-Gadget.Tests.ps1' = 10.5 }

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file

        $growth.Run | Should -Be '20990101-000000'
        $growth.Seconds | Should -Be 204.8
        $growth.GrowthSeconds | Should -Be 8.5
        $growth.GrownFiles | Should -Be 3
        $growth.TopFile | Should -Be 'Get-Widget.Tests.ps1'
        $growth.TopGrowthSeconds | Should -Be 3
        $growth.Spread | Should -BeTrue
    }

    It 'reads growth whose top file holds half or more as concentrated' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row $script:earlierRow | Out-Null
        $file = New-Row @{ 'Get-Widget.Tests.ps1' = 10; 'Get-Gadget.Tests.ps1' = 14; 'Set-Widget.Tests.ps1' = 12; 'Set-Gadget.Tests.ps1' = 12 }

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file

        $growth.TopFile | Should -Be 'Get-Gadget.Tests.ps1'
        $growth.TopGrowthSeconds | Should -Be 4
        $growth.GrowthSeconds | Should -Be 8
        $growth.Spread | Should -BeFalse
    }

    It 'takes the newest complete run of the kind, a failed one included, over an older passed one' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row $script:earlierRow -Duration 237.4 | Out-Null
        New-Run -Folder $script:folder -Name '20990101-010000' -Status 'failed' -Context $script:sourceContext -Row $script:earlierRow -Duration 235.3 | Out-Null
        $file = New-Row @{ 'Get-Widget.Tests.ps1' = 20 }

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file

        $growth.Run | Should -Be '20990101-010000'
        $growth.Seconds | Should -Be 235.3
    }

    It 'skips an abandoned, a crashed, an incomplete and another kind''s run, and the run itself' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row $script:earlierRow -Duration 200 | Out-Null
        New-Run -Folder $script:folder -Name '20990101-010000' -Status 'abandoned' -Context $script:sourceContext -Row (New-Row @{ 'Get-Widget.Tests.ps1' = 1 }) | Out-Null
        New-Run -Folder $script:folder -Name '20990101-020000' -Status 'crashed' -Context $script:sourceContext -Row (New-Row @{ 'Get-Widget.Tests.ps1' = 1 }) | Out-Null
        New-Run -Folder $script:folder -Name '20990101-030000' -Status 'failed' -Context $script:sourceContext -Row (New-Row @{ 'Get-Widget.Tests.ps1' = 1 }) -Incomplete | Out-Null
        $postBuild = [ordered]@{ run = 'source'; selection = 'post-build tests'; tiersRunning = 'L0-L2'; postBuild = $true }
        New-Run -Folder $script:folder -Name '20990101-040000' -Status 'passed' -Context $postBuild -Row (New-Row @{ 'Get-Widget.Tests.ps1' = 1 }) | Out-Null
        $modules = [ordered]@{ run = 'source'; selection = 'modules: TstWidget'; tiersRunning = 'L0-L2' }
        New-Run -Folder $script:folder -Name '20990101-050000' -Status 'passed' -Context $modules -Row (New-Row @{ 'Get-Widget.Tests.ps1' = 1 }) | Out-Null
        $file = New-Row @{ 'Get-Widget.Tests.ps1' = 20 }

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file

        $growth.Run | Should -Be '20990101-000000'
        $growth.Seconds | Should -Be 200
    }

    It 'keys bridged rows by their recorded folder, so each folder compares with itself and never with the shared bridge script' {
        $bridge = 'C:\repo\gadgets\Widget\assets\Gadget.Bridge.ps1'
        $bridged = {
            param([double] $Widget, [double] $Gadget)
            [pscustomobject]@{ File = $bridge; Key = 'bash/tests/widget'; DurationMs = $Widget * 1000 }
            [pscustomobject]@{ File = $bridge; Key = 'bash/tests/gadget'; DurationMs = $Gadget * 1000 }
        }
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row @(& $bridged 20 20) | Out-Null

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File @(& $bridged 21 26)

        $growth.TopFile | Should -Be 'bash/tests/gadget'
        $growth.TopGrowthSeconds | Should -Be 6
        $growth.GrowthSeconds | Should -Be 7
    }

    It 'leaves out a bridge row that records no key, since it names only the shared bridge script' {
        $keyless = { param([double] $Seconds) [pscustomobject]@{ File = 'C:\repo\gadgets\Widget\assets\Gadget.Bridge.ps1'; DurationMs = $Seconds * 1000 } }
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row (@($script:earlierRow) + @(& $keyless 20)) | Out-Null
        $file = @(New-Row @{ 'Get-Widget.Tests.ps1' = 14 }) + @(& $keyless 80)

        $growth = Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file

        $growth.GrowthSeconds | Should -Be 4
        $growth.TopFile | Should -Be 'Get-Widget.Tests.ps1'
    }

    It 'matches a row''s recorded key with an earlier row keyed by its path' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row $script:earlierRow | Out-Null
        $file = @([pscustomobject]@{ File = 'D:\sandbox\gadgets\Widget\tests\Get-Widget.Tests.ps1'; Key = 'gadgets/Widget/tests/Get-Widget.Tests.ps1'; DurationMs = 14000 })

        (Get-Growth -Folder $script:folder -RunDirectory $script:current -File $file).GrowthSeconds | Should -Be 4
    }

    It 'returns nothing when no earlier run of the kind ran to completion' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'abandoned' -Context $script:sourceContext -Row $script:earlierRow | Out-Null

        Get-Growth -Folder $script:folder -RunDirectory $script:current -File (New-Row @{ 'Get-Widget.Tests.ps1' = 20 }) | Should -BeNullOrEmpty
    }

    It 'returns nothing when the earlier run holds no file records' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row @() | Out-Null

        Get-Growth -Folder $script:folder -RunDirectory $script:current -File (New-Row @{ 'Get-Widget.Tests.ps1' = 20 }) | Should -BeNullOrEmpty
    }

    It 'returns nothing when the files grew by nothing' {
        New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row $script:earlierRow | Out-Null

        Get-Growth -Folder $script:folder -RunDirectory $script:current -File (New-Row @{ 'Get-Widget.Tests.ps1' = 9 }) | Should -BeNullOrEmpty
    }

    It 'skips an unreadable run record and an unreadable file record, never throwing' {
        $broken = New-Run -Folder $script:folder -Name '20990101-010000' -Status 'passed' -Context $script:sourceContext -Row $script:earlierRow
        [System.IO.File]::WriteAllText((Join-Path $broken 'run.json'), '{ not json')
        $gadget = New-Run -Folder $script:folder -Name '20990101-000000' -Status 'passed' -Context $script:sourceContext -Row $script:earlierRow
        [System.IO.File]::WriteAllText((Join-Path $gadget 'files-shard-0.json'), '{ not json')

        Get-Growth -Folder $script:folder -RunDirectory $script:current -File (New-Row @{ 'Get-Widget.Tests.ps1' = 20 }) | Should -BeNullOrEmpty
    }

    It 'returns nothing when the report folder does not exist' {
        Get-Growth -Folder (Join-Path $TestDrive 'missing') -RunDirectory $script:current -File (New-Row @{ 'Get-Widget.Tests.ps1' = 20 }) |
            Should -BeNullOrEmpty
    }
}
