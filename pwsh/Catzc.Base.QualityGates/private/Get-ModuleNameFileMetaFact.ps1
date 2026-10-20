<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-ModuleNameFileMetaFact.ps1
    folder: private
    name: get-module-name-file-meta-fact
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-ModuleNameFileMetaFact.Tests.ps1
    docs: "[Get-ModuleNameFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleNameFileMetaFact.ps1.md)"
    cites:
      - ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY
---
#>

function Get-ModuleNameFileMetaFact {
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

    $module = Get-PathModule $Path
    $value = if ($module) {
        $module.name
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
