function Get-LinksFileMetaFact {
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

    $page = (Get-Config -Config comments).PageFor($Path)
    [ordered]@{ $Kind.keys[0] = [string[]] @([Catzc.Base.QualityGates.DocumentLinks]::Of($State.Body, $Path, $page)) }
}
