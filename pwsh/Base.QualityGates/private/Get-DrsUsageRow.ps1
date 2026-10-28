function Get-DrsUsageRow {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.Drs.DrsCitationMap] $Map,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.CommentPagesConfig] $Pages,

        [Catzc.Base.CodeMeta.HeadForm] $Form,

        # The drs config's constants, which a caller over many files resolves once and passes in.
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        $CodeForm = (Get-Config -Config drs).CodeForm,

        [AllowEmptyCollection()]
        [string[]] $DomainClasses = (Get-Config -Config drs).DomainClasses,

        [string] $FileClass = (Get-FileKind $Path).Class,

        [Catzc.Base.Drs.DrsCitationScanner] $Scanner = [Catzc.Base.Drs.DrsCitationScanner]::new($CodeForm, $Map)
    )

    # The rows come from the file's text through the processors the imprint uses, never from its head.
    $isCode = $PSBoundParameters.ContainsKey('Form')
    $state = if ($isCode) {
        Get-CodeMetaState -Text $Text -Form $Form
    }
    else {
        Get-MarkdownMetaState -Text $Text
    }
    $citation = @{
        State          = $state
        Path           = $Path
        DomainClasses  = $DomainClasses
        RepositoryRoot = $RepositoryRoot
        Map            = $Map
        Pages          = $Pages
        Form           = $CodeForm
        FileClass      = $FileClass
        Scanner        = $Scanner
    }
    $adrs = @(Get-DrsCitation @citation)
    $links = @(if ($isCode) {
            @()
        }
        else {
            @([Catzc.Base.QualityGates.DocumentLinks]::Of($state.Body, $Path,
                    (Get-CommentPage -Path $Path -Config $Pages)))
        })

    foreach ($citation in $adrs) {
        # A fixture code or a placeholder named in a comment is no usage of an ADR.
        if (-not ($Map.HasCode($citation) -or $Map.IsDomainCode($citation))) {
            continue
        }
        $isRule = $Map.IsRule($citation)
        [pscustomobject]@{
            Path   = $Path
            Code   = if ($isRule) {
                $Map.RecordOf($citation)
            }
            else {
                $citation
            }
            Rule   = if ($isRule) {
                $citation
            }
            else {
                $null
            }
            Source = 'cites'
        }
    }

    foreach ($link in $links) {
        $target, $anchor = $link -split '#', 2
        $code = $Map.CodeOf($target)
        if (-not $code) {
            continue
        }
        [pscustomobject]@{ Path = $Path; Code = $code; Rule = $Map.RuleOfAnchor($code, $anchor); Source = 'link' }
    }
}
