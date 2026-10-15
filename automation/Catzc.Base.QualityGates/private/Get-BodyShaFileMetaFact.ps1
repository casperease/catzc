<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-BodyShaFileMetaFact.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

<#
.SYNOPSIS
    The body-sha meta kind's fact: the hash of the file's body below its front matter.
.DESCRIPTION
    The hash changes exactly when the body does; front matter and line endings never move it.
    [ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-BodyShaFileMetaFact.ps1.md#comment1)
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
function Get-BodyShaFileMetaFact {
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

    [ordered]@{ $Kind.keys[0] = $State.BodyHash }
}
