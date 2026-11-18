Describe 'Start-ScanWarmup' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot '../assets/importer/Start-ScanWarmup.ps1')
    }

    It 'reads the tree in a detached child, leaves the marker with the count outside the excluded folders, and starts nothing again' {
        $root = Join-Path $TestDrive 'widget'
        New-Item -ItemType Directory -Path (Join-Path $root 'widget-a/widget-b'), (Join-Path $root 'node_modules') -Force | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $root 'widget.txt'), 'widget')
        [System.IO.File]::WriteAllText((Join-Path $root 'widget-a/widget.ps1'), 'widget')
        [System.IO.File]::WriteAllText((Join-Path $root 'widget-a/widget-b/widget.yml'), 'widget')
        [System.IO.File]::WriteAllText((Join-Path $root 'node_modules/gadget.js'), 'gadget')
        $output = Join-Path $root 'out'

        $warmup = Start-ScanWarmup -RepositoryRoot $root -Signature '1.2.3.4' -OutputRoot $output
        $warmup.Started | Should -BeTrue
        $warmup.Marker | Should -Be ([System.IO.Path]::Combine($output, 'scan-warmup', '1.2.3.4.json'))

        # The child writes the count at its end; the wait is bounded at 20 s.
        $clock = [System.Diagnostics.Stopwatch]::StartNew()
        $files = $null
        while ($null -eq $files -and $clock.Elapsed.TotalSeconds -lt 20) {
            Start-Sleep -Milliseconds 100
            try {
                $marker = [System.IO.File]::ReadAllText($warmup.Marker) | ConvertFrom-Json
                $files = $marker.files
            }
            catch {
                $files = $null
            }
        }
        $files | Should -Be 3
        $marker.stoppedAtRoof | Should -BeFalse

        Start-ScanWarmup -RepositoryRoot $root -Signature '1.2.3.4' -OutputRoot $output | Should -BeNullOrEmpty
    }
}
