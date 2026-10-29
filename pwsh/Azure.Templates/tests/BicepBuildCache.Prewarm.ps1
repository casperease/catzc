# Fills the test run's bicep build cache before its workers start: each shipped template compiled once, whole, as the L2 files build it.
if (-not $env:CATZC_BICEP_BUILD_CACHE) {
    return
}
$bicep = Resolve-ToolExecutable -Tool bicep
if (-not ($bicep.Found -and $bicep.VersionOk)) {
    return
}
$prewarmRoot = Join-Path ([System.IO.Path]::GetDirectoryName($env:CATZC_BICEP_BUILD_CACHE)) 'bicep-prewarm'
foreach ($template in @(Get-BicepTemplateNames)) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $null = Build-Bicep $template -OutputFolder (Join-Path $prewarmRoot $template)
        Write-Message "Prewarmed '$template' in $([Math]::Round($stopwatch.Elapsed.TotalSeconds, 2)) s." -NoHeader
    }
    catch {
        Write-Message "Prewarm of '$template' failed, so its tests build it themselves: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
