<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1
    kind: fact-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-LINK#5
---
#>

<#
.SYNOPSIS
    The adr-codes meta kind's fact: the ADR citations the file and its comment page make, sorted and without duplicates.
.DESCRIPTION
    A citation is `ADR-<CODE>#<n>`; the colon form belongs to a rule's own heading and is no citation. A rule the file defines itself is
    listed under `defines`, never here. A file the kind's `domain_files` setting names also lists a bare `ADR-<CODE>`. A file the
    `held_files` setting names keeps every code its head already holds, so the head is where its citations live.
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
    if (-not $withDomain) {
        foreach ($defined in (Get-AdrDefinedRule -Text $text)) {
            [void] $codes.Remove($defined)
        }
    }
    $heldFiles = if ($Kind.settings.ContainsKey('held_files')) {
        @($Kind.settings['held_files'])
    }
    else {
        @()
    }
    $held = @($heldFiles | Where-Object { [Catzc.Base.Globs.GlobPattern]::new($_).Matches($Path) }).Count -gt 0
    if ($held -and $State.PSObject.Properties['DerivedLists'] -and $State.DerivedLists.Contains($Kind.keys[0])) {
        foreach ($code in $State.DerivedLists[$Kind.keys[0]]) {
            [void] $codes.Add($code)
        }
    }
    [ordered]@{ $Kind.keys[0] = [string[]] @($codes) }
}
