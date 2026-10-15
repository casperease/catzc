<#
.SYNOPSIS
    The file-path meta kind's fact: the file's repository-relative path
    ([ADR-REPO-MDMETA#3](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta3)).
.DESCRIPTION
    The path is a derived fact, so a moved file drifts and the formatter rewrites it; the H1 is the file's title, never its path
    ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)).
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
function Get-FilePathMarkdownMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind needs no state')]
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.MarkdownMetaKind] $Kind
    )

    [ordered]@{ $Kind.keys[0] = $Path }
}
