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
        @(Get-GitTrackedPath '.')
    }
    # Generated, vendor and unordered files are out by their track: generated targets as declared, the vendor folder and the unordered track.
    $generated = @(Get-GeneratedTarget).ForEach({ $_.path -replace '\*\*', '*' })
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
        $limit = try {
            Get-FileLimit -Path $file
        }
        catch {
            $issues.Add("$($file): unclassified, no language or extension declares it; give it a class in file-limits.yml (classes: or extensions:)")
            continue
        }
        foreach ($finding in @(Test-FileShape -Path $file)) {
            if ($finding.Check -eq 'width' -and $config.width_mode[$limit.file_class] -ne 'fail') {
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
