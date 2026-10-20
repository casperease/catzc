<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-VendorFileMetaFact.ps1
    folder: private
    name: get-vendor-file-meta-fact
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-VendorFileMetaFact.Tests.ps1
    docs: "[Get-VendorFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-VendorFileMetaFact.ps1.md)"
    cites:
      - ADR-DSGN-TRACKTYPE-OPTIONALVENDOR
      - ADR-DSGN-TRACKTYPE-HEADREADSDECLARATION
---
#>

function Get-VendorFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the vendor by path alone')]
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

    $track = Get-Track -Path $Path
    $value = if ($track -and $track.vendor) {
        $track.vendor
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
