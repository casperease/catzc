@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-CompletesWithin', 'Assert-IsNotTimeoutExempt', 'Assert-Wait', 'Get-TestTimeLimits', 'Get-TimeoutExemption', 'Get-TimeoutSeconds', 'Invoke-WithTimeout', 'Test-CompletesWithin', 'Test-IsTimeoutExempt')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('Assert-CompletesWithin.ps1', 'Assert-IsNotTimeoutExempt.ps1', 'Assert-Wait.ps1', 'Get-TestTimeLimits.ps1', 'Get-TimeoutExemption.ps1', 'Get-TimeoutSeconds.ps1', 'Invoke-WithTimeout.ps1', 'Test-CompletesWithin.ps1', 'Test-IsTimeoutExempt.ps1') }
}
