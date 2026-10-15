<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FilePathFileMetaFact.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-FILEMETA#3
      - ADR-REPO-FORMAT#6
---
#>

<#
.SYNOPSIS
    The file-path meta kind's fact: the file's repository-relative path.
.DESCRIPTION
    The path is derived, so a moved file drifts and the formatter rewrites it, while a Markdown H1 stays the title.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-FilePathFileMetaFact.ps1.md#comment1)
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
function Get-FilePathFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind needs no state')]
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

    [ordered]@{ $Kind.keys[0] = $Path }
}
