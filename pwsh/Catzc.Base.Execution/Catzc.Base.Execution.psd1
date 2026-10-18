@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Find-Executable', 'Invoke-Executable', 'Invoke-WithProgress', 'Reset-LastExitCode', 'Resolve-EngineExecutable', 'Resolve-ToolExecutable')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-ExecutableVersion.ps1', 'private/Invoke-ExecutableDirect.ps1', 'private/Invoke-ExecutableStreamed.ps1', 'Find-Executable.ps1', 'Invoke-Executable.ps1', 'Invoke-WithProgress.ps1', 'Reset-LastExitCode.ps1', 'Resolve-EngineExecutable.ps1', 'Resolve-ToolExecutable.ps1') }
}
