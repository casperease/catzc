function Test-RootConfigFiles {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $repositoryRoot = Get-RepositoryRoot
    # One check per managed file: a wildcard entry expands to the files its generator renders (none yet is none).
    $entries = @(foreach ($entry in @(Get-RootConfigTargets -Config (Get-Config -Config rootconfig))) {
            if ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($entry.target)) {
                foreach ($file in @(Get-RootConfigRenderedFile -Entry $entry)) {
                    [pscustomobject]@{ target = $file.Target; source = $entry.source; carrier = $entry.carrier; committed = [bool] $entry.committed }
                }
            }
            else {
                $entry
            }
        })
    $issues = [System.Collections.Generic.List[string]]::new()

    $ignored = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    if ($entries.Count -gt 0) {
        $quotedPaths = foreach ($entry in $entries) {
            "`"$($entry.target)`""
        }
        # Exit 0: some paths are ignored, 1: none are; anything else is a git failure.
        $ignoreResult = Invoke-Executable "git -C `"$repositoryRoot`" -c core.quotepath=off check-ignore --no-index -- $($quotedPaths -join ' ')" -PassThru -Silent -NoAssert
        if ($ignoreResult.ExitCode -gt 1) {
            throw "Test-RootConfigFiles: git check-ignore failed ($($ignoreResult.ExitCode)): $($ignoreResult.Errors)"
        }
        foreach ($line in ($ignoreResult.Output -split "`r?`n")) {
            if ($line) {
                [void]$ignored.Add($line)
            }
        }
    }

    foreach ($entry in $entries) {
        $target = $entry.target
        $isTracked = @(Get-GitTrackedPath $target).Count -gt 0
        $isIgnored = $ignored.Contains($target)
        if ($entry.committed) {
            if (-not $isTracked) {
                $issues.Add("${target}: committed:true but not tracked — it is needed before the importer runs")
            }
            if ($isIgnored) {
                $issues.Add("${target}: committed:true but matched by a .gitignore rule")
            }
        }
        else {
            if (-not $isIgnored) {
                $issues.Add("${target}: committed:false but no .gitignore rule ignores it")
            }
            if ($isTracked) {
                $issues.Add("${target}: committed:false but tracked — a gitignored artifact; run 'git rm --cached $target'")
            }
        }

        $targetPath = Join-Path $repositoryRoot $target
        $item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore
        if ($item -and $item.LinkType) {
            $issues.Add("${target}: a link, but must be a real, independent file — re-run the importer (Build-RootConfig rewrites it)")
        }
        elseif ($entry.source) {
            # A copy is its template under the generated head, byte for byte once the line endings are LF.
            $expected = Get-RootConfigCopyContent -Entry $entry -SourcePath (Join-Path $repositoryRoot $entry.source)
            if (-not $item) {
                $issues.Add("${target}: missing — re-run the importer (Build-RootConfig copies $($entry.source))")
            }
            elseif (([System.IO.File]::ReadAllText($targetPath) -replace "`r", '') -cne $expected) {
                $issues.Add("${target}: differs from $($entry.source) under its generated head — edit the template, then re-run the importer")
            }
        }
    }

    Write-QualityGateReport -Subject 'root-config-files' -Title 'Test-RootConfigFiles' -Issues $issues `
        -Facts ([ordered]@{ Files = $entries.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
