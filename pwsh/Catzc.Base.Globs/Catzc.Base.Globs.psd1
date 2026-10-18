@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Clear-GlobSetProtection', 'Get-ChangedGlobSet', 'Get-FileKind', 'Get-GlobSet', 'Get-GlobSetChangeRange', 'Get-GlobSetFile', 'Get-GlobSetHash', 'Get-GlobSetTrigger', 'Get-MarkerBlastRadius', 'Get-ModuleGlobSet', 'Get-TrackedFile', 'Protect-GlobSet', 'Test-AdoPipelineTriggerGlob', 'Test-GitHubWorkflowTriggerGlob', 'Test-GlobSetAffected', 'Test-GlobSetIndependence', 'Test-GlobSetProtection', 'Test-GlobSetTriggerCoverage')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-ChangedFile.ps1', 'private/Get-GlobSetMember.ps1', 'private/Get-PipelineTrigger.ps1', 'private/Test-GlobListEqual.ps1', 'Clear-GlobSetProtection.ps1', 'Get-ChangedGlobSet.ps1', 'Get-FileKind.ps1', 'Get-GlobSet.ps1', 'Get-GlobSetChangeRange.ps1', 'Get-GlobSetFile.ps1', 'Get-GlobSetHash.ps1', 'Get-GlobSetTrigger.ps1', 'Get-MarkerBlastRadius.ps1', 'Get-ModuleGlobSet.ps1', 'Get-TrackedFile.ps1', 'Protect-GlobSet.ps1', 'Test-AdoPipelineTriggerGlob.ps1', 'Test-GitHubWorkflowTriggerGlob.ps1', 'Test-GlobSetAffected.ps1', 'Test-GlobSetIndependence.ps1', 'Test-GlobSetProtection.ps1', 'Test-GlobSetTriggerCoverage.ps1') }
}
