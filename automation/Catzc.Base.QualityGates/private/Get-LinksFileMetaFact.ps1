<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-LinksFileMetaFact.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

<#
.SYNOPSIS
    The links meta kind's fact: every link the file points at, in one spelling, sorted and without duplicates.
.DESCRIPTION
    A link into the file itself, to an anchor in it, or to its own comment page stays internal and is not listed.
    [ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
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
