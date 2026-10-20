<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-FileRoleFileMetaFact.ps1
    folder: private
    name: get-file-role-file-meta-fact
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-FileRoleFileMetaFact.Tests.ps1
    docs: "[Get-FileRoleFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-FileRoleFileMetaFact.ps1.md)"
    cites:
      - ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
---
#>

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
