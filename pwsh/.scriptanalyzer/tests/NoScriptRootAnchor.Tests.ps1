<#
---
catzc:
  docs: "../../../docs/references/pwsh/scriptanalyzer/tests/NoScriptRootAnchor.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Measure-NoScriptRootAnchor' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/NoScriptRootAnchor.psm1') -Force
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
        }

        $script:anchoredCode = @'
function Get-Widget {
    Get-Content -Path (Join-Path $PSScriptRoot 'assets/widget.txt')
}
'@

        function Test-ScriptRootAnchorFile {
            param([string] $Code, [string] $RelativePath)
            $path = Join-Path $TestDrive (Join-Path (Get-CatzcModulesFolder) $RelativePath)
            New-Item -ItemType Directory -Path (Split-Path -Path $path -Parent) -Force | Out-Null
            Set-Content -Path $path -Value $Code
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            Measure-NoScriptRootAnchor -ScriptBlockAst $ast
        }
    }

    It 'flags $PSScriptRoot in a module function file: <Description>' -ForEach @(
        @{ Description = 'public (module root)'; RelativePath = 'Catzc.Widget/Get-Widget.ps1' }
        @{ Description = 'private/'; RelativePath = 'Catzc.Widget/private/Get-Widget.ps1' }
    ) {
        $diagnostics = @(Test-ScriptRootAnchorFile -Code $script:anchoredCode -RelativePath $RelativePath)
        $diagnostics.Count | Should -Be 1
        $diagnostics[0].RuleName | Should -Be 'Measure-NoScriptRootAnchor'
        $diagnostics[0].Extent.Text | Should -Be '$PSScriptRoot'
    }

    It 'reports one diagnostic per reference' {
        $code = @'
function Get-Gadget {
    $first = Join-Path $PSScriptRoot 'configs/gadget.yml'
    $second = Join-Path $PSScriptRoot 'assets/gadget.txt'
    $first, $second
}
'@
        @(Test-ScriptRootAnchorFile -Code $code -RelativePath 'Catzc.Gadget/Get-Gadget.ps1').Count | Should -Be 2
    }

    It 'carries the ADR-cited message pointing at Get-CatzcModuleRoot' {
        $diagnostic = Test-ScriptRootAnchorFile -Code $script:anchoredCode -RelativePath 'Catzc.Widget/Get-Widget.ps1'
        $diagnostic.Message | Should -Be "Locate module-internal content with Get-CatzcModuleRoot -ChildPath '<literal>' (ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY); `$PSScriptRoot does not point at the module folder in build mode."
        $diagnostic.Severity | Should -Be 'Error'
    }

    It 'exempts <Description>' -ForEach @(
        @{ Description = 'module tests/'; RelativePath = 'Catzc.Widget/tests/Get-Widget.Tests.ps1' }
        @{ Description = 'module assets/'; RelativePath = 'Catzc.Widget/assets/scripts/install-widget.ps1' }
        @{ Description = '.internal'; RelativePath = '.internal/Widget.ps1' }
        @{ Description = '.scriptanalyzer'; RelativePath = '.scriptanalyzer/Widget.ps1' }
        @{ Description = '.vendor'; RelativePath = '.vendor/Gadget/1.0.0/Widget.ps1' }
        @{ Description = 'a repository-root script'; RelativePath = 'widget.ps1' }
        @{ Description = 'infrastructure/'; RelativePath = 'infrastructure/widget/deploy-widget.ps1' }
    ) {
        Test-ScriptRootAnchorFile -Code $script:anchoredCode -RelativePath $RelativePath | Should -BeNullOrEmpty
    }

    It 'passes a module function file that uses Get-CatzcModuleRoot' {
        $code = @'
function Get-Widget {
    Get-Content -Path (Get-CatzcModuleRoot -ChildPath 'assets/widget.txt')
}
'@
        Test-ScriptRootAnchorFile -Code $code -RelativePath 'Catzc.Widget/Get-Widget.ps1' | Should -BeNullOrEmpty
    }

    It 'does not flag $PSScriptRoot as text in comments or emitted code (literal and escaped strings)' {
        $code = @'
function New-Gadget {
    # The emitted gadget script anchors on $PSScriptRoot at its own load time.
    $lines = @(
        '$env:GadgetRoot = $PSScriptRoot'
        "`$env:WidgetRoot = Join-Path `$PSScriptRoot 'widget'"
    )
    $lines
}
'@
        Test-ScriptRootAnchorFile -Code $code -RelativePath 'Catzc.Gadget/private/New-Gadget.ps1' | Should -BeNullOrEmpty
    }

    It 'does not flag a script analysed without a file path' {
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($script:anchoredCode, [ref]$null, [ref]$null)
        Measure-NoScriptRootAnchor -ScriptBlockAst $ast | Should -BeNullOrEmpty
    }
}
