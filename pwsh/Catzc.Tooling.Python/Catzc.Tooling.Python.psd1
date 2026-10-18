@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Install-Poetry', 'Install-PySpark', 'Install-Python', 'Invoke-Pip', 'Invoke-Poetry', 'Invoke-PySpark', 'Invoke-Python', 'Remove-Python', 'Uninstall-Poetry', 'Uninstall-PySpark', 'Uninstall-Python')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Install-PipTool.ps1', 'private/Uninstall-PipTool.ps1', 'Install-Poetry.ps1', 'Install-PySpark.ps1', 'Install-Python.ps1', 'Invoke-Pip.ps1', 'Invoke-Poetry.ps1', 'Invoke-PySpark.ps1', 'Invoke-Python.ps1', 'Remove-Python.ps1', 'Uninstall-Poetry.ps1', 'Uninstall-PySpark.ps1', 'Uninstall-Python.ps1') }
}
