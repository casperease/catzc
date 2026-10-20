<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-CommittedTypesDrift.ps1
    folder: private
    name: get-committed-types-drift
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-CommittedTypesDrift.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-CommittedTypesDrift.ps1.md)"
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
    $modulesFolder = Get-CatzcModulesFolder
    $compiled = "$modulesFolder/.compiled"
    $currentHash = (Get-CombinedTypeHash (Join-Path $RepositoryRoot $modulesFolder)).CombinedHash

    $compiledRoot = Join-Path $RepositoryRoot $compiled
    # @() around the whole if: a single match must stay an array (.Count under strict mode).
    $dlls = @(if ([System.IO.Directory]::Exists($compiledRoot)) {
            foreach ($dll in [System.IO.Directory]::EnumerateFiles($compiledRoot, 'Catzc.Types.*.dll')) {
                [System.IO.Path]::GetFileName($dll)
            }
        })

    $reasons = [System.Collections.Generic.List[string]]::new()
    $expected = "Catzc.Types.$currentHash.dll"
    if ($dlls.Count -ne 1) {
        $reasons.Add("$compiled holds $($dlls.Count) Catzc.Types.*.dll ($($dlls -join ', ')); expected exactly $expected — run the importer")
    }
    elseif ($dlls[0] -ne $expected) {
        $reasons.Add("$compiled/$($dlls[0]) is not the current assembly $expected — run the importer")
    }
    $expectedManifest = "Catzc.Types.$currentHash.json"
    $manifests = @(if ([System.IO.Directory]::Exists($compiledRoot)) {
            foreach ($manifest in [System.IO.Directory]::EnumerateFiles($compiledRoot, 'Catzc.Types.*.json')) {
                [System.IO.Path]::GetFileName($manifest)
            }
        })
    if ($manifests.Count -ne 1 -or $manifests[0] -ne $expectedManifest) {
        $reasons.Add("$compiled holds $($manifests.Count) Catzc.Types.*.json ($($manifests -join ', ')); expected exactly $expectedManifest beside the assembly — run the importer")
    }
    if (Test-GitPathChanged $compiled) {
        $reasons.Add("$compiled has pending git changes — commit the rebuilt Catzc.Types.<hash>.dll")
    }

    [string[]] $reasons.ToArray()
}
