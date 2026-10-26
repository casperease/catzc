function Get-ContractFragmentFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.ContractAsset] $Asset
    )

    $missing = @(Get-ContractPresenceFindings -RepositoryRoot $RepositoryRoot -Path $Asset.Target)
    if ($missing.Count -gt 0) {
        return $missing
    }

    if (-not (Get-ContractDataFormat -Path $Asset.Target)) {
        $fragmentText = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $Asset.AssetPath))
        $targetText = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $Asset.Target))
        return [Catzc.Base.Contracts.ContractFragment]::MatchLines($fragmentText, $targetText)
    }

    try {
        $fragment = ConvertTo-BclValue (Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.AssetPath)
        $target = ConvertTo-BclValue (Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.Target)
    }
    catch {
        return $_.Exception.Message
    }
    [Catzc.Base.Contracts.ContractFragment]::MatchData($fragment, $target)
}
