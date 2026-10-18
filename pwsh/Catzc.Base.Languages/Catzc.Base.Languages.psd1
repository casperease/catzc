@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Format-GeneratedFileHead', 'Get-FileLanguage', 'Get-PathFileType', 'Invoke-BashTest', 'Invoke-GoTest', 'Invoke-PythonTest', 'New-GoWorkspace', 'New-PythonProject', 'Test-GeneratedFileCurrent')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/ConvertFrom-BatsJunit.ps1', 'private/ConvertFrom-GoTestJson.ps1', 'private/ConvertFrom-PytestJunit.ps1', 'private/Get-EngineContract.ps1', 'private/Get-GeneratorPath.ps1', 'Format-GeneratedFileHead.ps1', 'Get-FileLanguage.ps1', 'Get-PathFileType.ps1', 'Invoke-BashTest.ps1', 'Invoke-GoTest.ps1', 'Invoke-PythonTest.ps1', 'New-GoWorkspace.ps1', 'New-PythonProject.ps1', 'Test-GeneratedFileCurrent.ps1') }
}
