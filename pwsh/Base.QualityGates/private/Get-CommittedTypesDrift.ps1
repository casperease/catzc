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
    $currentHash = (Get-CombinedTypeHash (Join-Path $RepositoryRoot $modulesFolder)).CombinedHash
    $contract = Get-TypesContractPath -RepositoryRoot $RepositoryRoot
    $reasons = [System.Collections.Generic.List[string]]::new()

    # The surface the current sources build to, read from their build in the shadow root, against the committed contract.
    $dll = Join-Path (Get-TypesShadowRoot) "Catzc.Types.$currentHash.dll"
    if (-not (Test-Path -LiteralPath $dll -PathType Leaf)) {
        $reasons.Add("no build of the current type sources ($currentHash) in the shadow root — run the importer")
        return [string[]] $reasons.ToArray()
    }
    foreach ($reason in @(Get-TypesContractDrift -Path $dll -RepositoryRoot $RepositoryRoot)) {
        $reasons.Add($reason)
    }
    if (Test-GitPathChanged $contract) {
        $reasons.Add("$contract has pending git changes — commit the regenerated types surface")
    }

    [string[]] $reasons.ToArray()
}
