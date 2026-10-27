function Test-NetworkCalls {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Catzc.Base.Execution.NetworkCallsConfig] $Config = (Get-Config -Config network-calls -Module Catzc.Base.Execution),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $repositoryRoot = Get-RepositoryRoot
    $tracked = [string[]] @(Get-GitTrackedPath '.')
    $trackedSet = [System.Collections.Generic.HashSet[string]]::new($tracked, [System.StringComparer]::Ordinal)
    $registered = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($site in $Config.sites.Values) {
        [void]$registered.Add($site.path)
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    $scanned = 0
    foreach ($file in $tracked) {
        if (@($Config.skip | Where-Object { $file -like $_ }).Count) {
            continue
        }
        $lines = Get-NetworkCallLines -Root $repositoryRoot -File $file
        if ($null -eq $lines) {
            continue
        }
        $scanned++
        if ($registered.Contains($file)) {
            continue
        }
        $number = 0
        foreach ($line in $lines) {
            $number++
            if ($line -match '^\s*(#|//)') {
                continue
            }
            foreach ($name in $Config.Matches($line)) {
                $issues.Add("${file}:${number}: a $name call in a file with no registered site — add its '<file>#<function or job>' entry to network-calls.yml (ADR-AUTO-NET-REGISTRYGATE)")
            }
        }
    }

    foreach ($key in $Config.sites.Keys) {
        $site = $Config.sites[$key]
        if ($site.IsViolation) {
            $issues.Add("${key}: trigger default-path — a network call on a default path (ADR-AUTO-NET-NODEFAULTPATH); fix it and move the entry to its guarded trigger")
        }
        if (-not $trackedSet.Contains($site.path)) {
            $issues.Add("${key}: the file is not tracked — remove the entry or correct its path")
            continue
        }
        $lines = @(Get-NetworkCallLines -Root $repositoryRoot -File $site.path)
        $code = @($lines | Where-Object { $_ -notmatch '^\s*(#|//)' })
        if (-not @($code | Where-Object { $Config.Matches($_).Count }).Count) {
            $issues.Add("${key}: the file matches no network pattern — remove the entry, or add the pattern its call needs")
        }
        $named = [regex]::new('(?<![\w-])' + [regex]::Escape($site.name) + '(?![\w-])')
        if (-not @($lines | Where-Object { $named.IsMatch($_) }).Count) {
            $issues.Add("${key}: the file no longer names '$($site.name)' — correct the key's function or job")
        }
    }

    Write-QualityGateReport -Subject network-calls -Title Test-NetworkCalls -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Files = $tracked.Count; Scanned = $scanned; Sites = $Config.sites.Count; Patterns = $Config.patterns.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
