function Test-FileLimits {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        # The tracked paths to check, repository-relative; every tracked file in scope by default.
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $config = Get-Config -Config file-limits
    $tracked = if ($Path) {
        $Path
    }
    else {
        # A tracked file deleted on disk but not yet committed has nothing to measure; the next commit drops it from the index.
        @(Get-GitTrackedPath '.').Where({ [System.IO.File]::Exists($_) })
    }
    # A comment page is authored prose though its root is a generated target, so it stays in scope.
    $authored = @(foreach ($page in (Get-Config -Config comment-pages).pages) {
            ($page.docs -replace '\{[^}]+\}', '*') + '/*'
        })
    $generated = @(@(Get-GeneratedTarget).ForEach({ $_.path -replace '\*\*', '*' }).Where({ $_ -notin $authored }))
    $outFolders = @([Catzc.Base.Folders.FolderWalkConfig]::VendorFolder, '.unordered', '.compiled')
    $inScope = @($tracked.Where({
                $file = $_ -replace '\\', '/'
                $segments = $file.Split('/')
                -not ($segments.Where({ $_ -in $outFolders }, 'First')) -and -not ($generated.Where({ $file -like $_ }, 'First'))
            }))

    $issues = [System.Collections.Generic.List[string]]::new()
    $widthReports = [System.Collections.Generic.List[string]]::new()
    $exempted = 0
    foreach ($file in $inScope) {
        $null = try {
            Get-FileLimit -Path $file
        }
        catch {
            $issues.Add("$($file): unclassified, no language or extension declares it; give it a class in file-limits.yml (classes: or extensions:)")
            continue
        }
        foreach ($finding in @(Test-FileShape -Path $file)) {
            # Width is measured and reported, never enforced: a wide line informs, only a long file fails the gate.
            if ($finding.Check -eq 'width') {
                $widthReports.Add($finding.Message)
            }
            elseif ($config.exempt.ContainsKey(($file -replace '\\', '/'))) {
                $exempted++
            }
            else {
                $issues.Add($finding.Message)
            }
        }
    }

    Write-QualityGateReport -Subject file-limits -Title Test-FileLimits -Issues ([string[]] @($issues)) `
        -Facts ([ordered]@{ Files = $inScope.Count; Exempt = $exempted; WidthReported = $widthReports.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
