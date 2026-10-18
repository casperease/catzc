@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('ConvertFrom-AdoPipelineCommand', 'Get-AdoAuthorizationHeader', 'Get-AdoPipelineDefinitions', 'Get-AdoRepositoryName', 'Get-AdoYamlFiles', 'Get-AdoYamlInventory', 'Invoke-AdoRestMethod', 'New-AdoPullRequest', 'Register-AdoPipeline', 'Set-AdoPipelineVariable', 'Sync-AdoEnvironmentApprovals', 'Test-Pipelines', 'Write-AdoEnvironmentDiagnostic')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-AdoGraphContext.ps1', 'private/Get-PipelineTemplateReference.ps1', 'private/Resolve-AdoYamlClassification.ps1', 'private/Sync-AdoEnvironmentCheck.ps1', 'private/Sync-AdoGraphGroup.ps1', 'private/Sync-AdoGraphGroupMembers.ps1', 'ConvertFrom-AdoPipelineCommand.ps1', 'Get-AdoAuthorizationHeader.ps1', 'Get-AdoPipelineDefinitions.ps1', 'Get-AdoRepositoryName.ps1', 'Get-AdoYamlFiles.ps1', 'Get-AdoYamlInventory.ps1', 'Invoke-AdoRestMethod.ps1', 'New-AdoPullRequest.ps1', 'Register-AdoPipeline.ps1', 'Set-AdoPipelineVariable.ps1', 'Sync-AdoEnvironmentApprovals.ps1', 'Test-Pipelines.ps1', 'Write-AdoEnvironmentDiagnostic.ps1') }
}
