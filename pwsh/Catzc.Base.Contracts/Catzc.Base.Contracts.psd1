@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Build-ContractReference', 'Get-CommandContract', 'Get-Contract', 'Get-ContractCheckResults', 'New-CatsCommandLookup', 'Publish-ContractRelease', 'Test-Contracts')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/ConvertTo-ContractNoteMarkdown.ps1', 'private/Get-ContractAssetKind.ps1', 'private/Get-ContractAssetNote.ps1', 'private/Get-ContractBindingAssets.ps1', 'private/Get-ContractCheckResult.ps1', 'private/Get-ContractCommandFindings.ps1', 'private/Get-ContractCommandRoot.ps1', 'private/Get-ContractDataFormat.ps1', 'private/Get-ContractDotFolderFindings.ps1', 'private/Get-ContractFileHashes.ps1', 'private/Get-ContractFragmentFindings.ps1', 'private/Get-ContractFreezeFindings.ps1', 'private/Get-ContractPresenceFindings.ps1', 'private/Get-ContractSampleFindings.ps1', 'private/Get-ContractSchemaFindings.ps1', 'private/Get-ContractUnitAsset.ps1', 'private/Get-ContractVersionAsset.ps1', 'private/Read-CommandSignature.ps1', 'private/Read-ContractData.ps1', 'private/Read-ContractManifest.ps1', 'private/Resolve-ContractAsset.ps1', 'Build-ContractReference.ps1', 'Get-CommandContract.ps1', 'Get-Contract.ps1', 'Get-ContractCheckResults.ps1', 'New-CatsCommandLookup.ps1', 'Publish-ContractRelease.ps1', 'Test-Contracts.ps1') }
}
