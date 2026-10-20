<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-FileNameFileMetaFact.ps1
    folder: private
    name: get-file-name-file-meta-fact
    filetype: ps1
    role: function
    subkind: fact
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-FileNameFileMetaFact.Tests.ps1
    docs: "[Get-FileNameFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-FileNameFileMetaFact.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-ROLE
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
