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
    # Every module group's types surface, one pathspec git expands itself.
    $contract = 'contracts/catzc/0.1.0/*/types.json'
    $reasons = [System.Collections.Generic.List[string]]::new()

    # The surface the current sources build to, read from their build in the shadow root, against the committed contracts.
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
