<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1
    folder: private
    name: get-track-file-meta-fact
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
    docs: "[Get-TrackFileMetaFact.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md)"
    cites:
      - ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER
---
#>

function Get-TrackFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the track by path alone')]
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
    $name = if ($track) {
        $track.name
    }
    else {
        ''
    }
    [ordered]@{ $Kind.keys[0] = $name }
}
