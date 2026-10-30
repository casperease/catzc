# Fills the test run's bicep build cache before its workers start: each shipped template compiled once, whole, as the L2 files build it.
if (-not $env:CATZC_BICEP_BUILD_CACHE) {
    return
}
$bicep = Resolve-ToolExecutable -Tool bicep
if (-not ($bicep.Found -and $bicep.VersionOk)) {
    return
}
$prewarmRoot = Join-Path ([System.IO.Path]::GetDirectoryName($env:CATZC_BICEP_BUILD_CACHE)) 'bicep-prewarm'
$templates = @(Get-BicepTemplateNames)
# The first template builds here; each other one builds in a process of its own, side by side.
$children = foreach ($template in @($templates | Select-Object -Skip 1)) {
    $command = ". '$(Get-RepositoryRoot)/importer.ps1' -SkipJanitors; `$null = Build-Bicep '$template' -OutputFolder '$(Join-Path $prewarmRoot $template)'"
    [pscustomobject]@{
        Template = $template
        Process  = Start-Process pwsh -ArgumentList '-NoProfile', '-Command', $command -NoNewWindow -PassThru
    }
}
foreach ($template in @($templates | Select-Object -First 1)) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $null = Build-Bicep $template -OutputFolder (Join-Path $prewarmRoot $template)
        Write-Message "Prewarmed '$template' in $([Math]::Round($stopwatch.Elapsed.TotalSeconds, 2)) s." -NoHeader
    }
    catch {
        Write-Message "Prewarm of '$template' failed, so its tests build it themselves: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
foreach ($child in @($children)) {
    if (-not $child.Process.WaitForExit([int] (Get-TimeoutSeconds -Command Build-Bicep) * 1000)) {
        $child.Process.Kill($true)
    }
    if ($child.Process.ExitCode -ne 0) {
        Write-Message "Prewarm of '$($child.Template)' failed, so its tests build it themselves." -ForegroundColor Yellow
    }
}
