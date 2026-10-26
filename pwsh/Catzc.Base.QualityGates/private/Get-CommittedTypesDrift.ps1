<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-CommittedTypesDrift.ps1.md"
  header: "generated"
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
    $reasons = [System.Collections.Generic.List[string]]::new()
    $expectedManifest = "Catzc.Types.$currentHash.json"
    # @() around the whole loop: a single match must stay an array (.Count under strict mode).
    $manifests = @(foreach ($manifest in [Catzc.Base.Folders.PathSet]::new().AddPattern($compiledRoot, 'Catzc.Types.*.json', 1).ToArray()) {
            [System.IO.Path]::GetFileName($manifest)
        })
    if ($manifests.Count -ne 1 -or $manifests[0] -ne $expectedManifest) {
        $reasons.Add("$compiled holds $($manifests.Count) Catzc.Types.*.json ($($manifests -join ', ')); expected exactly $expectedManifest — run the importer")
    }
    if (Test-GitPathChanged $compiled) {
        $reasons.Add("$compiled has pending git changes — commit the rebuilt Catzc.Types.<hash>.json")
    }

    [string[]] $reasons.ToArray()
}
