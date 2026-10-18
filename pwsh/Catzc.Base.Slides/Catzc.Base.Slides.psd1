@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Build-Diagrams', 'Build-SlideDeck', 'Test-Slides')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-AdrRuleText.ps1', 'private/Get-SlideFinding.ps1', 'private/Get-SlidesKit.ps1', 'private/Read-SlideFile.ps1', 'Build-Diagrams.ps1', 'Build-SlideDeck.ps1', 'Test-Slides.ps1') }
}
