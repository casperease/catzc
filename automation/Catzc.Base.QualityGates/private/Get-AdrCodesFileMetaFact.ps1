<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-FILEMETA#3
      - ADR-REPO-LINK#5
---
#>

<#
.SYNOPSIS
    The adr-codes meta kind's fact: the ADR citations the file and its comment page make, sorted and without duplicates.
.DESCRIPTION
    A citation is `ADR-<CODE>#<n>`; the colon form belongs to a rule's own heading and is no citation. A file the kind's `domain_files`
    setting names also lists a bare `ADR-<CODE>`.
    [ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3),
    [ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-AdrCodesFileMetaFact.ps1.md#comment1)
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
function Get-AdrCodesFileMetaFact {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaKind] $Kind
    )

    $text = if ($State.PSObject.Properties['Body']) {
        $State.Body
    }
    else {
        $State.Rest
    }
    $repositoryRoot = Get-RepositoryRoot
    $page = (Get-Config -Config comments).PageFor($Path)
    if ($page -and (Test-Path -LiteralPath (Join-Path $repositoryRoot $page) -PathType Leaf)) {
        $text += "`n" + (Get-MarkdownMetaState -Text ([System.IO.File]::ReadAllText((Join-Path $repositoryRoot $page)))).Body
    }

    $domainFiles = if ($Kind.settings.ContainsKey('domain_files')) {
        @($Kind.settings['domain_files'])
    }
    else {
        @()
    }
    $withDomain = @($domainFiles | Where-Object { [Catzc.Base.Globs.GlobPattern]::new($_).Matches($Path) }).Count -gt 0
    $pattern = if ($withDomain) {
        '(?<![\w-])ADR-[A-Z]+(?:-[A-Z]+)*(?:#\d+|(?![\w#-]|:\d))'
    }
    else {
        '(?<![\w-])ADR-[A-Z]+(?:-[A-Z]+)*#\d+'
    }
    $codes = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($text, $pattern)) {
        [void] $codes.Add($match.Value)
    }
    [ordered]@{ $Kind.keys[0] = [string[]] @($codes) }
}
