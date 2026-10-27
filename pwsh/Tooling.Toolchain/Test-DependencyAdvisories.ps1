function Test-DependencyAdvisories {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        # A lock file to scan as it is; without it the Python workspace's uv.lock is produced from the commit first.
        [string] $LockFile,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $osv = Resolve-ToolExecutable -Tool osv_scanner
    if (-not ($osv.Found -and $osv.VersionOk)) {
        throw "The dependency scan needs osv-scanner at the tools.yml pin '$($osv.Required)' (found: $($osv.Version ?? 'none')). Run Install-OsvScanner."
    }

    if (-not $LockFile) {
        # uv.lock is per-machine output (gitignored), so it is resolved from the generated pyproject here, never read as left behind.
        $uv = Resolve-ToolExecutable -Tool uv
        if (-not ($uv.Found -and $uv.VersionOk)) {
            throw "The dependency scan needs the managed uv at the tools.yml pin '$($uv.Required)' (found: $($uv.Version ?? 'none')). Run Install-Uv."
        }
        $repositoryRoot = Get-RepositoryRoot
        $pythonRelative = (Get-Config -Config python).ResolveRoot($repositoryRoot)
        $pythonRoot = Join-Path $repositoryRoot $pythonRelative
        Assert-PathExist (Join-Path $pythonRoot 'pyproject.toml') -PathType Leaf -ErrorText "$pythonRelative/pyproject.toml is missing — the Python test workspace is generated; regenerate with: Build-RootConfig"
        $lock = Invoke-Executable "`"$($uv.Path)`" lock --quiet" -WorkingDirectory $pythonRoot -PassThru -NoAssert -Silent
        if ($lock.ExitCode -ne 0) {
            throw "uv lock failed in $pythonRelative/ (exit $($lock.ExitCode)):`n$($lock.Full)"
        }
        $LockFile = Join-Path $pythonRoot 'uv.lock'
    }
    Assert-PathExist $LockFile -PathType Leaf

    # Exit 0: no advisory; 1: advisories found; anything else is a scanner failure.
    $scan = Invoke-Executable "`"$($osv.Path)`" scan source --lockfile `"$LockFile`" --format json" -PassThru -NoAssert -Silent
    if ($scan.ExitCode -gt 1) {
        throw "osv-scanner failed (exit $($scan.ExitCode)) on '$LockFile':`n$($scan.Full)"
    }
    $report = if ([string]::IsNullOrWhiteSpace($scan.Output)) {
        $null
    }
    else {
        $scan.Output | ConvertFrom-Json
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    $packages = 0
    foreach ($result in @($report.results | Where-Object { $_ })) {
        foreach ($entry in @($result.packages | Where-Object { $_ })) {
            $packages++
            foreach ($vulnerability in @($entry.vulnerabilities | Where-Object { $_ })) {
                $issues.Add("$($entry.package.name) $($entry.package.version) ($($entry.package.ecosystem)): $($vulnerability.id) $($vulnerability.summary) — raise the pin past the fixed version")
            }
        }
    }

    Write-QualityGateReport -Subject 'dependency-advisories' -Title 'Test-DependencyAdvisories' -Issues $issues `
        -Facts ([ordered]@{ LockFile = (ConvertTo-RepoRelativePath $LockFile); AffectedPackages = $packages }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
