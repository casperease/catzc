@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Write-CallStack', 'Write-CmdletParameterSet', 'Write-EnvironmentDiagnostic', 'Write-Exception', 'Write-Footer', 'Write-Header', 'Write-Message', 'Write-Object')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Resolve-WriterColor.ps1', 'private/Write-FramedLine.ps1', 'private/Write-InformationColored.ps1', 'Write-CallStack.ps1', 'Write-CmdletParameterSet.ps1', 'Write-EnvironmentDiagnostic.ps1', 'Write-Exception.ps1', 'Write-Footer.ps1', 'Write-Header.ps1', 'Write-Message.ps1', 'Write-Object.ps1') }
}
