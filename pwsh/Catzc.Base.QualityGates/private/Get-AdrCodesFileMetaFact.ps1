<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1
    folder: private
    name: get-adr-codes-file-meta-fact
    filetype: ps1
    role: function
    subkind: fact
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
    docs: "[Get-AdrCodesFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-AdrCodesFileMetaFact.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-NOREADBACK
      - ADR-REPO-LINK-ONECITATIONSPELLING
---
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
    $page = Get-CommentPage -Path $Path -Config (Get-Config -Config comment-pages)
    if ($page -and (Test-Path -LiteralPath (Join-Path $repositoryRoot $page) -PathType Leaf)) {
        $text += "`n" + (Get-MarkdownMetaState -Text ([System.IO.File]::ReadAllText((Join-Path $repositoryRoot $page)))).Body
    }

    $fileClass = (Get-FileKind $Path).Class
    $withDomain = [Catzc.Base.QualityGates.FileMetaKind]::InClasses($Kind.ClassSetting('domain_classes'), $fileClass)
    $map = Get-AdrCitationMap -RepositoryRoot $repositoryRoot
    $codes = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($text, '(?<![\w-])ADR(?:-[A-Z][A-Z0-9]*)+(?![\w#-]|:\d)')) {
        [void] $codes.Add($match.Value)
    }
    if (-not $withDomain) {
        foreach ($defined in (Get-AdrDefinedRule -Text $text)) {
            [void] $codes.Remove($defined)
        }
    }
    # Only a code the ADR index registers is a citation: a fixture code or a placeholder named in prose is not.
    foreach ($code in @($codes)) {
        $registered = $map.IsRule($code) -or ($withDomain -and ($map.HasCode($code) -or $map.IsDomainCode($code)))
        if (-not $registered) {
            [void] $codes.Remove($code)
        }
    }
    [ordered]@{ $Kind.keys[0] = [string[]] @([Catzc.Base.Docs.AdrCodeForm]::Minimize([string[]] @($codes), $map)) }
}
