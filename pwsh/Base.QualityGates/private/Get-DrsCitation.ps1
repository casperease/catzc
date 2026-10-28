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
        [string] $FileClass = (Get-FileKind $Path).Class,

        # The compiled scan, built once per run from the form and the map.
        [Catzc.Base.Drs.DrsCitationScanner] $Scanner = [Catzc.Base.Drs.DrsCitationScanner]::new($Form, $Map)
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
    # Only a code the DRS index registers is a citation; numbered and wildcard forms are mentions.
    [string[]] $Scanner.Citations($text, $withDomain)
}
