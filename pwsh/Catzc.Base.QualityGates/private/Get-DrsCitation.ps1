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
        [string[]] $DomainClasses = (Get-Config -Config drs).DomainClasses
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
    $withDomain = [Catzc.Base.QualityGates.FileMetaKind]::InClasses($DomainClasses, $fileClass)
    $map = Get-DrsCitationMap -RepositoryRoot $repositoryRoot
    $form = (Get-Config -Config drs).CodeForm
    $defined = @(if ($withDomain) {
            @()
        }
        else {
            @(Get-DrsDefinedRule -Text $text)
        })
    # A ```yml drawio block's codes are the diagram's, not the prose's.
    $prose = [regex]::Replace($text, '(?m)^```yml drawio[ \t]*\r?\n(?:(?!```)[^\r\n]*\r?\n)*```[ \t]*$', '')
    $found = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($prose, "(?<![\w-])$($form.Cited)(?![\w#-]|:\d)")) {
        [void] $found.Add($match.Value)
    }
    foreach ($rule in $defined) {
        [void] $found.Remove($rule)
    }
    foreach ($code in @($found)) {
        $own = @($defined | Where-Object { $_.StartsWith("$code-", [System.StringComparison]::Ordinal) }).Count -gt 0
        $registered = $map.IsRule($code) -or ($map.HasCode($code) -and -not $own) -or ($withDomain -and
            $map.IsDomainCode($code))
        if (-not $registered) {
            [void] $found.Remove($code)
        }
    }
    [string[]] @($form.Minimize([string[]] @($found), $map))
}
