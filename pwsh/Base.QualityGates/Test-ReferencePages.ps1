function Test-ReferencePages {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $tracked = [string[]] @(Get-GitTrackedPath '.')
    $config = Get-Config -Config comment-pages
    $index = $config.PageIndex($tracked)
    $articles = [System.Collections.Generic.HashSet[string]]::new([string[]] @($config.articles), [System.StringComparer]::Ordinal)
    $issues = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)

    # A page two sources render to is a collision; the gate names it and resolves nothing.
    foreach ($page in $index.Keys) {
        if ($index[$page].Count -gt 1) {
            [void] $issues.Add("$page is the page of $($index[$page].Count) sources ($($index[$page] -join ', ')); rename one so each page maps back to exactly one source")
        }
    }

    # Every page under a pages docs folder maps back to a source, or is an authored article the config lists.
    $pages = @($tracked | Where-Object { $_.EndsWith('.md', [System.StringComparison]::Ordinal) -and $config.IsInScope($_) })
    foreach ($page in $pages) {
        if (-not $index.ContainsKey($page) -and -not $articles.Contains($page)) {
            [void] $issues.Add("$page maps back to no source file; move it to its source's derived page, delete it, or list it under articles in comment-pages.yml")
        }
    }
    foreach ($article in $articles) {
        if ($index.ContainsKey($article)) {
            [void] $issues.Add("$article is listed under articles but is the derived page of $($index[$article] -join ', '); drop it from articles")
        }
    }

    Write-QualityGateReport -Subject reference-pages -Title Test-ReferencePages -Issues ([string[]] @($issues)) `
        -Facts ([ordered]@{ Pages = $pages.Count; Derived = $index.Count; Articles = $articles.Count }) -OutputFolder $OutputFolder `
        -PassThru:$PassThru
}
