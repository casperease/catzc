<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-DrsCitation.ps1.md"
  header: "generated"
---
#>

function Get-DrsCitation {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [AllowEmptyCollection()]
        [string[]] $DomainClasses = (Get-Config -Config drs).DomainClasses,

        # The run's constants, which a caller over many files resolves once and passes in.
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [Catzc.Base.Drs.DrsCitationMap] $Map = (Get-DrsCitationMap -RepositoryRoot $RepositoryRoot),

        [Catzc.Base.CodeMeta.CommentPagesConfig] $Pages = (Get-Config -Config comment-pages),

        $Form = (Get-Config -Config drs).CodeForm,

        # The file's kind class, which a scope that already resolved it passes in.
        [string] $FileClass = (Get-FileKind $Path).Class
    )

    $text = if ($State.PSObject.Properties['Body']) {
        $State.Body
    }
    else {
        $State.Rest
    }
    $page = Get-CommentPage -Path $Path -Config $Pages
    if ($page) {
        $pageFile = Join-Path $RepositoryRoot $page
        if ([System.IO.File]::Exists($pageFile)) {
            $text += "`n" + (Get-MarkdownMetaState -Text ([System.IO.File]::ReadAllText($pageFile))).Body
        }
    }

    $withDomain = [Catzc.Base.QualityGates.FileMetaKind]::InClasses($DomainClasses, $FileClass)
    $defined = @(if ($withDomain) {
            @()
        }
        else {
            @(Get-DrsDefinedRule -Text $text -Form $Form)
        })
    # A ```yml drawio block's codes are the diagram's, not the prose's.
    $prose = [regex]::Replace($text, '(?m)^```yml drawio[ \t]*\r?\n(?:(?!```)[^\r\n]*\r?\n)*```[ \t]*$', '')
    $found = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($prose, "(?<![\w-])$($Form.Cited)(?![\w#-]|:\d)")) {
        [void] $found.Add($match.Value)
    }
    foreach ($rule in $defined) {
        [void] $found.Remove($rule)
    }
    foreach ($code in @($found)) {
        $own = @($defined | Where-Object { $_.StartsWith("$code-", [System.StringComparison]::Ordinal) }).Count -gt 0
        $registered = $Map.IsRule($code) -or ($Map.HasCode($code) -and -not $own) -or ($withDomain -and
            $Map.IsDomainCode($code))
        if (-not $registered) {
            [void] $found.Remove($code)
        }
    }
    [string[]] @($Form.Minimize([string[]] @($found), $Map))
}
