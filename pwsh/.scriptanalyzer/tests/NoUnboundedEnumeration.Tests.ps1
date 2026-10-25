<#
---
catzc:
  docs: "../../../docs/references/pwsh/scriptanalyzer/tests/NoUnboundedEnumeration.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Measure-NoUnboundedEnumeration' -Tag 'L0', 'logic', 'ADR-PWSH-ENUM-RAWDOTNETENUMERATION', 'ADR-PWSH-ENUM-ALWAYSBOUNDED' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/NoUnboundedEnumeration.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
        }

        function Test-EnumerationFile {
            param([string] $Code, [string] $RelativePath = 'Catzc.Widget/Get-Widget.ps1')
            $path = Join-Path $TestDrive (Join-Path (Get-CatzcModulesFolder) $RelativePath)
            New-Item -ItemType Directory -Path (Split-Path -Path $path -Parent) -Force | Out-Null
            Set-Content -Path $path -Value $Code
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            Measure-NoUnboundedEnumeration -ScriptBlockAst $ast
        }
    }

    It 'flags a filesystem listing cmdlet: <Command>' -ForEach @(
        @{ Command = 'Get-ChildItem' }
        @{ Command = 'gci' }
        @{ Command = 'dir' }
        @{ Command = 'ls' }
    ) {
        $diagnostics = @(Test-EnumerationFile -Code "function Get-Widget { $Command `$widgetFolder -Recurse }")
        $diagnostics.Count | Should -Be 1
        $diagnostics | ForEach-Object { $_.RuleName } | Should -Be 'Measure-NoUnboundedEnumeration'
        $diagnostics | ForEach-Object { $_.Message } | Should -BeLike '*Get-ChildPath*'
    }

    It 'flags a drive-letter path as a filesystem path' {
        @(Test-EnumerationFile -Code 'function Get-Widget { Get-ChildItem C:\widget }').Count | Should -Be 1
    }

    It 'flags SearchOption.AllDirectories: <Spelling>' -ForEach @(
        @{ Spelling = 'System.IO.SearchOption'; Code = 'function Get-Widget { [System.IO.Directory]::GetFiles($widgetFolder, ''*'', [System.IO.SearchOption]::AllDirectories) }' }
        @{ Spelling = 'IO.SearchOption'; Code = 'function Get-Widget { [IO.Directory]::GetFiles($widgetFolder, ''*'', [IO.SearchOption]::AllDirectories) }' }
    ) {
        $diagnostics = @(Test-EnumerationFile -Code $Code)
        $diagnostics.Count | Should -Be 1
        $diagnostics | ForEach-Object { $_.Message } | Should -BeLike '*-Depth*'
        $diagnostics | ForEach-Object { $_.Extent.Text } | Should -BeLike '*AllDirectories'
    }

    It 'leaves a provider listing alone: <Path>' -ForEach @(
        @{ Path = 'env:' }
        @{ Path = 'function:' }
        @{ Path = 'variable:' }
        @{ Path = 'HKLM:\SOFTWARE\Widget' }
    ) {
        @(Test-EnumerationFile -Code "function Get-Widget { Get-ChildItem $Path }").Count | Should -Be 0
    }

    It 'flags a listing in a test file as well' {
        $code = 'function Get-Widget { Get-ChildItem $widgetFolder -Recurse }'
        @(Test-EnumerationFile -Code $code -RelativePath 'Catzc.Widget/tests/Get-Widget.Tests.ps1').Count | Should -Be 1
    }

    It 'leaves a Mock of the cmdlet and the cmdlet name in a string alone' {
        $code = @'
Mock Get-ChildItem { } -ModuleName Catzc.Widget
$text = 'Get-ChildItem is the cmdlet'
'@
        @(Test-EnumerationFile -Code $code -RelativePath 'Catzc.Widget/tests/Get-Widget.Tests.ps1').Count | Should -Be 0
    }

    It 'does not flag a one-level raw listing or Get-ChildPath' {
        $code = @'
function Get-Widget {
    [System.IO.Directory]::GetFiles($widgetFolder, '*', [System.IO.SearchOption]::TopDirectoryOnly)
    Get-ChildPath $widgetFolder -File -Depth 2
}
'@
        @(Test-EnumerationFile -Code $code).Count | Should -Be 0
    }
}
