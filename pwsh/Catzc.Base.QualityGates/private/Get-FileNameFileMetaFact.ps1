function Get-FileNameFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the file name by path alone')]
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

    $module = Get-PathModule $Path
    $tail = if ($module -and $module.tail) {
        $module.tail
    }
    else {
        $Path
    }
    $parts = [Catzc.Base.Languages.PathParts]::Of($tail)
    $facts = [ordered]@{}
    $facts[$Kind.keys[0]] = $parts.folder
    $facts[$Kind.keys[1]] = $parts.name
    $facts
}
