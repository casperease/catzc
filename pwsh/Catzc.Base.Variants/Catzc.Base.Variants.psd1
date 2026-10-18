@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-AdoNaming', 'Assert-HaveCustomer', 'Assert-HaveCustomers', 'Get-AdoNaming', 'Get-EnabledCustomers', 'Get-GitWorkspace', 'Get-PathModule', 'Get-Track', 'Test-AdoNaming', 'Test-GitWorkspace', 'Test-HaveCustomer', 'Test-HaveCustomers', 'Test-TrackDeclaration')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-Variant.ps1', 'Assert-AdoNaming.ps1', 'Assert-HaveCustomer.ps1', 'Assert-HaveCustomers.ps1', 'Get-AdoNaming.ps1', 'Get-EnabledCustomers.ps1', 'Get-GitWorkspace.ps1', 'Get-PathModule.ps1', 'Get-Track.ps1', 'Test-AdoNaming.ps1', 'Test-GitWorkspace.ps1', 'Test-HaveCustomer.ps1', 'Test-HaveCustomers.ps1', 'Test-TrackDeclaration.ps1') }
}
