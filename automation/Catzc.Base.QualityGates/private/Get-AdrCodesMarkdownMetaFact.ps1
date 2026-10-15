<#
.SYNOPSIS
    The adr-codes meta kind's fact: the rule citations the file's body makes, sorted and without duplicates
    ([ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)).
.DESCRIPTION
    A citation is `ADR-<CODE>#<n>` ([ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)); the colon form
    belongs to a rule's own heading and is no citation. The order is ordinal, so a rerun never moves a code.
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
function Get-AdrCodesMarkdownMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind needs no path')]
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

    $codes = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($State.Body, '(?<![\w-])ADR-[A-Z]+(?:-[A-Z]+)*#\d+')) {
        [void] $codes.Add($match.Value)
    }
    [ordered]@{ $Kind.keys[0] = [string[]] @($codes) }
}
