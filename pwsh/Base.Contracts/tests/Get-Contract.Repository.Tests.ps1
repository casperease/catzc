Describe 'Get-Contract on the repository' -Tag 'L1', 'integrity', 'ADR-REPO-CONTRACT-LAYOUT' {
    It 'lists every version of every unit without error' {
        $assets = @(Get-Contract -Version *)
        foreach ($asset in $assets) {
            $asset | Should -BeOfType ([Catzc.Base.Contracts.ContractAsset])
            $asset.AssetPath | Should -BeLike 'contracts/*'
        }
    }
}
