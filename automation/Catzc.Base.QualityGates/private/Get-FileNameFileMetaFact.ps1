<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-FileNameFileMetaFact.ps1
    folder: private
    name: get-file-name-file-meta-fact
    filetype: ps1
    kind: function
    subkind: fact
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-FileNameFileMetaFact.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#11
---
#>

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
