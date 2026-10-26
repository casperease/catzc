Describe 'PipelineWatchdog' -Tag 'L0', 'logic' {
    It 'stops a pipeline that outlives its limit, and says it fired' {
        $pipeline = [PowerShell]::Create([System.Management.Automation.RunspaceMode]::CurrentRunspace).AddScript('Start-Sleep -Seconds 5')
        $watchdog = [Catzc.Base.Timeouts.PipelineWatchdog]::new($pipeline, [timespan]::FromMilliseconds(50))
        try {
            $null = $pipeline.Invoke()
        }
        catch [System.Management.Automation.MethodInvocationException] {
            $null = $_
        }
        finally {
            $watchdog.Dispose()
            $pipeline.Dispose()
        }
        $watchdog.Fired | Should -BeTrue
    }

    It 'never stops a pipeline after Dispose, even when the limit passes as the pipeline returns' {
        # The limit lands around each return, so the timer fires before, during and after dispose; a stray stop would end the process.
        foreach ($run in 1..200) {
            $pipeline = [PowerShell]::Create([System.Management.Automation.RunspaceMode]::CurrentRunspace).AddScript('1')
            $watchdog = [Catzc.Base.Timeouts.PipelineWatchdog]::new($pipeline,
                [timespan]::FromTicks(1000 + ($run % 20) * 500))
            try {
                $null = $pipeline.Invoke()
            }
            catch [System.Management.Automation.MethodInvocationException] {
                $null = $_
            }
            finally {
                $watchdog.Dispose()
                $pipeline.Dispose()
            }
        }
        # Give any timer callback still queued from the last runs the chance to run against its disposed pipeline.
        Start-Sleep -Milliseconds 100
        $true | Should -BeTrue
    }
}
