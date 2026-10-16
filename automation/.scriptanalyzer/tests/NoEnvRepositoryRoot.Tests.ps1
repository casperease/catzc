<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/NoEnvRepositoryRoot.Tests.ps1
    folder: automation/.scriptanalyzer/tests
    name: no-env-repository-root-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    relatives:
      page: docs/references/automation/scriptanalyzer/tests/NoEnvRepositoryRoot.Tests.ps1.md
    adrs:
      - ADR-AUTO-NOPWD#6
---
#>

Describe 'Measure-NoEnvRepositoryRoot' -Tag 'L0', 'logic', 'ADR-AUTO-NOPWD#6' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoEnvRepositoryRoot.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        $script:readingCode = @'
function Get-Widget {
    Join-Path $env:RepositoryRoot 'widget.txt'
}
'@

        function Test-EnvRootFile {
            param([string] $Code, [string] $RelativePath)
            $path = Join-Path $TestDrive $RelativePath
            New-Item -ItemType Directory -Path (Split-Path -Path $path -Parent) -Force | Out-Null
            Set-Content -Path $path -Value $Code
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            Measure-NoEnvRepositoryRoot -ScriptBlockAst $ast
        }
    }

    It 'flags a read in a module function file: <Description>' -ForEach @(
        @{ Description = 'public (module root)'; RelativePath = 'automation/Catzc.Widget/Get-Widget.ps1' }
        @{ Description = 'private/'; RelativePath = 'automation/Catzc.Widget/private/Get-Widget.ps1' }
    ) {
        $diagnostics = @(Test-EnvRootFile -Code $script:readingCode -RelativePath $RelativePath)
        $diagnostics.Count | Should -Be 1
        $diagnostics | ForEach-Object { $_.RuleName } | Should -Be 'Measure-NoEnvRepositoryRoot'
        $diagnostics | ForEach-Object { $_.Extent.Text } | Should -Be '$env:RepositoryRoot'
    }

    It 'leaves alone: <Description>' -ForEach @(
        @{ Description = 'a test file'; RelativePath = 'automation/Catzc.Widget/tests/Get-Widget.Tests.ps1' }
        @{ Description = 'an asset'; RelativePath = 'automation/Catzc.Widget/assets/widget.ps1' }
        @{ Description = 'dot-prefixed infrastructure'; RelativePath = 'automation/.internal/Get-Widget.ps1' }
        @{ Description = 'a file outside automation/'; RelativePath = 'widget.ps1' }
        @{ Description = 'the accessor itself'; RelativePath = 'automation/Catzc.Widget/Get-RepositoryRoot.ps1' }
    ) {
        @(Test-EnvRootFile -Code $script:readingCode -RelativePath $RelativePath).Count | Should -Be 0
    }

    It 'does not flag an assignment, only the read on its right-hand side' {
        $code = @'
function Set-Widget {
    $env:RepositoryRoot = 'C:\widget'
}
'@
        @(Test-EnvRootFile -Code $code -RelativePath 'automation/Catzc.Widget/Set-Widget.ps1').Count | Should -Be 0
    }

    It 'does not flag another environment variable' {
        $code = @'
function Get-Gadget {
    $env:GadgetRoot
}
'@
        @(Test-EnvRootFile -Code $code -RelativePath 'automation/Catzc.Widget/Get-Gadget.ps1').Count | Should -Be 0
    }
}
