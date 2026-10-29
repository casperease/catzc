Describe 'Wait-PesterRunner' -Tag 'logic' {
    Context 'a stopped call (real pwsh workers)' -Tag 'L2', 'greedy' {
        It 'returns within seconds and leaves no worker or worker child alive' {
            # The widget worker starts a child of its own, so the stop must take the whole tree.
            $marker = Join-Path $TestDrive 'widget-child.pid'
            $widget = Join-Path $TestDrive 'widget.ps1'
            $gadget = Join-Path $TestDrive 'gadget.ps1'
            $quotedMarker = $marker -replace "'", "''"
            [System.IO.File]::WriteAllText($widget, @"
`$child = Start-Process pwsh -ArgumentList '-NoProfile', '-Command', 'Start-Sleep -Seconds 120' -PassThru -NoNewWindow
[System.IO.File]::WriteAllText('$quotedMarker.tmp', "`$(`$child.Id)")
[System.IO.File]::Move('$quotedMarker.tmp', '$quotedMarker')
Start-Sleep -Seconds 120
"@)
            [System.IO.File]::WriteAllText($gadget, 'Start-Sleep -Seconds 120')

            $runner = [Catzc.Base.QualityGates.PesterRunner]::Start(@($widget, $gadget), @('widget', 'gadget'), 2, $null, 300, $true)
            # The module's own function text, run in a second runspace, so this thread can stop it as Ctrl-C stops a pipeline.
            $definition = & (Get-Module Catzc.Base.QualityGates) { ${function:Wait-PesterRunner}.ToString() }
            $shell = [powershell]::Create()
            try {
                $null = $shell.AddScript("function Wait-PesterRunner {$definition}`nWait-PesterRunner -Runner `$args[0]").AddArgument($runner)
                $null = $shell.BeginInvoke()
                $deadline = [DateTime]::UtcNow.AddSeconds(60)
                while (-not [System.IO.File]::Exists($marker) -and [DateTime]::UtcNow -lt $deadline) {
                    Start-Sleep -Milliseconds 100
                }
                [System.IO.File]::Exists($marker) | Should -BeTrue -Because 'the widget worker starts its child before it sleeps'
                $runIds = @($runner.ProcessIds) + @([int] [System.IO.File]::ReadAllText($marker))
                $runIds.Count | Should -Be 3

                $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
                $shell.Stop()
                $stopwatch.Elapsed.TotalSeconds | Should -BeLessThan 15
                $shell.InvocationStateInfo.State | Should -Be 'Stopped'
            }
            finally {
                $null = $runner.Stop()
                $shell.Dispose()
            }
            foreach ($id in $runIds) {
                Get-Process -Id $id -ErrorAction SilentlyContinue | Should -BeNullOrEmpty -Because "process $id belongs to the stopped run"
            }
        }
    }

    Context 'a finished pool (real pwsh workers)' -Tag 'L2' {
        It 'returns the runner with its results and stops nothing' {
            $widget = Join-Path $TestDrive 'finished-widget.ps1'
            [System.IO.File]::WriteAllText($widget, "Write-Output 'widget-out'")

            $runner = & (Get-Module Catzc.Base.QualityGates) {
                param($Script)
                Wait-PesterRunner -Runner ([Catzc.Base.QualityGates.PesterRunner]::Start(@($Script), @('widget'), 1, $null, 120, $true))
            } $widget

            $runner.Results[0].Stdout | Should -BeLike '*widget-out*'
            $runner.Stop() | Should -Be 0
        }
    }
}
