@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-Command', 'Assert-False', 'Assert-HaveProperty', 'Assert-IsAdministrator', 'Assert-IsGuid', 'Assert-IsGuidInRange', 'Assert-LastExitCodeWasZero', 'Assert-NotNull', 'Assert-NotNullOrWhitespace', 'Assert-PathExist', 'Assert-PipelineCount', 'Assert-PsModule', 'Assert-True', 'Assert-TypeIs', 'Assert-YmlNaming', 'Test-Command', 'Test-HaveProperty', 'Test-IsAdministrator', 'Test-IsGuid', 'Test-IsGuidInRange', 'Test-NotNullOrWhitespace')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('Assert-Command.ps1', 'Assert-False.ps1', 'Assert-HaveProperty.ps1', 'Assert-IsAdministrator.ps1', 'Assert-IsGuid.ps1', 'Assert-IsGuidInRange.ps1', 'Assert-LastExitCodeWasZero.ps1', 'Assert-NotNull.ps1', 'Assert-NotNullOrWhitespace.ps1', 'Assert-PathExist.ps1', 'Assert-PipelineCount.ps1', 'Assert-PsModule.ps1', 'Assert-True.ps1', 'Assert-TypeIs.ps1', 'Assert-YmlNaming.ps1', 'Test-Command.ps1', 'Test-HaveProperty.ps1', 'Test-IsAdministrator.ps1', 'Test-IsGuid.ps1', 'Test-IsGuidInRange.ps1', 'Test-NotNullOrWhitespace.ps1') }
}
