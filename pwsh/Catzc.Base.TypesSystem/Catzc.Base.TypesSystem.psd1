@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-LoadedTypesCurrent', 'Build-BashTimeoutHook', 'Clear-ModuleTypeCache', 'Get-CSharpTypeDependency', 'Invoke-BuildForVSCode', 'Test-LoadedTypesCurrent', 'Test-ShippedTypes')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Format-FileLockingProcess.ps1', 'private/Stop-FileLockingProcess.ps1', 'private/Test-ConsoleReadyType.ps1', 'Assert-LoadedTypesCurrent.ps1', 'Build-BashTimeoutHook.ps1', 'Clear-ModuleTypeCache.ps1', 'Get-CSharpTypeDependency.ps1', 'Invoke-BuildForVSCode.ps1', 'Test-LoadedTypesCurrent.ps1', 'Test-ShippedTypes.ps1') }
}
