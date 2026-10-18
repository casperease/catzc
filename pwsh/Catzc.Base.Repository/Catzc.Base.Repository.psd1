@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-SourceTree', 'ConvertTo-RepoRelativePath', 'Get-CatzcModuleRoot', 'Get-CatzcModulesFolder', 'Get-CatzcModulesRoot', 'Get-CatzcOverlayRoot', 'Get-CatzcRunMode', 'Get-OutputRoot', 'Get-RepositoryFile', 'Get-RepositoryFolder', 'Get-RepositoryRoot', 'Get-RunEnvironment', 'Get-SessionActor', 'Resolve-RepoPath', 'Test-IsRunningAsAgent')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('Assert-SourceTree.ps1', 'ConvertTo-RepoRelativePath.ps1', 'Get-CatzcModuleRoot.ps1', 'Get-CatzcModulesFolder.ps1', 'Get-CatzcModulesRoot.ps1', 'Get-CatzcOverlayRoot.ps1', 'Get-CatzcRunMode.ps1', 'Get-OutputRoot.ps1', 'Get-RepositoryFile.ps1', 'Get-RepositoryFolder.ps1', 'Get-RepositoryRoot.ps1', 'Get-RunEnvironment.ps1', 'Get-SessionActor.ps1', 'Resolve-RepoPath.ps1', 'Test-IsRunningAsAgent.ps1') }
}
