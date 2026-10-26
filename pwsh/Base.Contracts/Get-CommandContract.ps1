function Get-CommandContract {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractCommand[]])]
    param(
        [Parameter(Position = 0)]
        [SupportsWildcards()]
        [string[]] $Name = '*',

        [SupportsWildcards()]
        [string[]] $Module = '*',

        [SupportsWildcards()]
        [string[]] $Root = '*',

        [SupportsWildcards()]
        [string[]] $Version = '0.1.0',

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $suffix = [Catzc.Base.Contracts.ContractCommand]::Suffix
    foreach ($asset in Get-Contract -Root $Root -Version $Version -Group $Module -Path "*$suffix" -RepositoryRoot $RepositoryRoot) {
        if ($asset.Kind -ne [Catzc.Base.Contracts.ContractAssetKind]::Command) {
            continue
        }
        $command = [Catzc.Base.Contracts.ContractCommand]::NameOf($asset)
        if (@($Name | Where-Object { $command -like $_ }).Count -eq 0) {
            continue
        }
        try {
            $raw = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $asset.AssetPath
            $contract = [Catzc.Base.Contracts.ContractCommand]::new($asset, $raw)
        }
        catch {
            $reason = $_.Exception.InnerException ? $_.Exception.InnerException.Message : $_.Exception.Message
            throw "contract asset '$($asset.AssetPath)': $reason"
        }
        $findings = @(Get-ContractNormalFormFindings -Contract $contract)
        if ($findings.Count -gt 0) {
            throw "contract asset '$($asset.AssetPath)': $($findings -join '; ')"
        }
        $contract
    }
}
