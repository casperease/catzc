function Get-FileRoleFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind classifies by path alone')]
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

    $match = Get-FileKind $Path
    $fact = [ordered]@{ $Kind.keys[0] = $match.role }
    if ($Kind.keys.Count -gt 1) {
        $fact[$Kind.keys[1]] = $(if ($match.subkind) {
                $match.subkind
            }
            else {
                ''
            })
    }
    $fact
}
