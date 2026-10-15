<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-CommittedTypesDrift.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
  config:
    synopsis: Reports why the committed combined types assembly is not the current one.
    description: |-
      The build ships the committed automation/.compiled/Catzc.Types.<hash>.dll by copy, so that file must be the
      assembly of the current type sources: exactly one Catzc.Types.*.dll, named for the combined hash of the
      sources (Get-CombinedTypeHash, the one implementation the loader and the janitor share), and no pending git
      change under automation/.compiled — the importer rebuilds the DLL when a types/*.cs changes, and a rebuild
      that was not committed shows there. Each failure is one reason; none means the committed assembly is current.
    parameters:
      RepositoryRoot: The repository whose automation/.compiled is checked.
    outputs: '[string[]] One reason per drift found; nothing when the committed assembly is current.'
    examples:
      - Get-CommittedTypesDrift -RepositoryRoot (Get-RepositoryRoot)
---
#>

function Get-CommittedTypesDrift {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    Import-InternalModule Types
    $currentHash = (Get-CombinedTypeHash (Join-Path $RepositoryRoot 'automation')).CombinedHash

    $compiledRoot = Join-Path $RepositoryRoot 'automation/.compiled'
    # @() around the whole if: a single match must stay an array (.Count under strict mode).
    $dlls = @(if ([System.IO.Directory]::Exists($compiledRoot)) {
            foreach ($dll in [System.IO.Directory]::EnumerateFiles($compiledRoot, 'Catzc.Types.*.dll')) {
                [System.IO.Path]::GetFileName($dll)
            }
        })

    $reasons = [System.Collections.Generic.List[string]]::new()
    $expected = "Catzc.Types.$currentHash.dll"
    if ($dlls.Count -ne 1) {
        $reasons.Add("automation/.compiled holds $($dlls.Count) Catzc.Types.*.dll ($($dlls -join ', ')); expected exactly $expected — run the importer")
    }
    elseif ($dlls[0] -ne $expected) {
        $reasons.Add("automation/.compiled/$($dlls[0]) is not the current assembly $expected — run the importer")
    }
    $expectedManifest = "Catzc.Types.$currentHash.json"
    $manifests = @(if ([System.IO.Directory]::Exists($compiledRoot)) {
            foreach ($manifest in [System.IO.Directory]::EnumerateFiles($compiledRoot, 'Catzc.Types.*.json')) {
                [System.IO.Path]::GetFileName($manifest)
            }
        })
    if ($manifests.Count -ne 1 -or $manifests[0] -ne $expectedManifest) {
        $reasons.Add("automation/.compiled holds $($manifests.Count) Catzc.Types.*.json ($($manifests -join ', ')); expected exactly $expectedManifest beside the assembly — run the importer")
    }
    if (Test-GitPathChanged 'automation/.compiled') {
        $reasons.Add('automation/.compiled has pending git changes — commit the rebuilt Catzc.Types.<hash>.dll')
    }

    [string[]] $reasons.ToArray()
}
