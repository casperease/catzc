<#
---
catzc:
  immutable:
    with_body_sha: "10496a204017"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-SkippedClassCitationFinding.Tests.ps1
---
#>

function Get-SkippedClassCitationFinding {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $kind = @((Get-Config -Config file-meta).kinds | Where-Object { $_.id -ceq 'adr-codes' }) | Select-Object -First 1
    if (-not $kind) {
        return
    }
    $pages = Get-Config -Config comment-pages
    $fileKinds = Get-Config -Config file-kinds
    $languages = Get-Config -Config languages

    $prefixes = @($Path | Where-Object { $_ } | ForEach-Object { $_.Replace('\', '/').TrimEnd('/') })
    foreach ($source in @(Get-GitTrackedPath '.')) {
        if ($prefixes.Count -gt 0 -and -not @($prefixes | Where-Object { $source -ceq $_ -or $source.StartsWith("$_/", [System.StringComparison]::Ordinal) })) {
            continue
        }
        $page = $pages.PageFor($source)
        if (-not $page -or -not [System.IO.File]::Exists((Join-Path $RepositoryRoot $page))) {
            continue
        }
        $class = $fileKinds.Resolve($source).Class
        $language = $languages.ForPath($source)?.name
        if ($kind.Selects($class, $language)) {
            continue
        }
        # The page alone: the one parser of the codes, given no body, reads what the comment page cites.
        $codes = @((Get-DrsCodesFileMetaFact -State ([pscustomobject]@{ Body = '' }) -Path $source -Kind $kind)[$kind.keys[0]])
        if ($codes.Count -gt 0) {
            "${page}:1 [SkippedClassCitation] cites $($codes -join ', ') for $source, whose class '$class' the adr-codes select in " +
            'file-meta.yml skips, so its head never cites them — add the class to the select, or cite the rules where a selected file carries them'
        }
    }
}
