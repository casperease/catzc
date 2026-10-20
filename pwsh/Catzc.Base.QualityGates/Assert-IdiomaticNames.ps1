function Assert-IdiomaticNames {
    [CmdletBinding()]
    param()

    Assert-SourceTree

    $issues = @((Get-Config -Config languages).MisnamedPaths([string[]] @(Get-GitTrackedPath '.')))
    if ($issues.Count -gt 0) {
        throw "$($issues.Count) file and folder name(s) break their language's naming (Catzc.Base.Languages configs/languages.yml):`n$($issues -join "`n")"
    }
}
