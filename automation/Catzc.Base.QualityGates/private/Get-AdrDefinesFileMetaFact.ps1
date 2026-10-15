<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrDefinesFileMetaFact.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

<#
.SYNOPSIS
    The adr-defines meta kind's fact: the rules an ADR defines itself, spelled as citations.
.DESCRIPTION
    The rules come from the file's own rule headings, so the list is what the file declares and not what it cites.
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
function Get-AdrDefinesFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind needs no path')]
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

    [ordered]@{ $Kind.keys[0] = [string[]] @(Get-AdrDefinedRule -Text $State.Body) }
}
