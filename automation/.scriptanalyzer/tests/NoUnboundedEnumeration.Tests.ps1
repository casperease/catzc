<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/NoUnboundedEnumeration.Tests.ps1
    kind: pester-test
---
#>

# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
# ScriptBlockAst. Its scope is decided by the file path, so each case writes a fixture file into $TestDrive and parses it
# from there. The engine-wiring proof lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
Describe 'Measure-NoUnboundedEnumeration' -Tag 'L0', 'logic', 'ADR-PWSH-ENUM#1', 'ADR-PWSH-ENUM#3' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoUnboundedEnumeration.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-EnumerationFile {
            param([string] $Code, [string] $RelativePath = 'automation/Catzc.Widget/Get-Widget.ps1')
            $path = Join-Path $TestDrive $RelativePath
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
        $diagnostics | ForEach-Object { $_.Message } | Should -BeLike '*ADR-PWSH-ENUM#1*'
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
        $diagnostics | ForEach-Object { $_.Message } | Should -BeLike '*ADR-PWSH-ENUM#3*'
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

    It 'leaves a test file alone' {
        $code = 'function Get-Widget { Get-ChildItem $widgetFolder -Recurse }'
        @(Test-EnumerationFile -Code $code -RelativePath 'automation/Catzc.Widget/tests/Get-Widget.Tests.ps1').Count | Should -Be 0
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
