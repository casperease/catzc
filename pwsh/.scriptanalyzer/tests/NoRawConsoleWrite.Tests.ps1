<#
---
catzc:
  docs: "../../../docs/references/pwsh/scriptanalyzer/tests/NoRawConsoleWrite.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Measure-NoRawConsoleWrite' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/NoRawConsoleWrite.psm1') -Force
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
        }

        function Test-RawConsole {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoRawConsoleWrite -ScriptBlockAst $ast
        }
    }

    It 'flags a console write past the information stream: <Desc>' -ForEach @(
        @{ Desc = 'Write-Host'; Code = "Write-Host 'widget'" }
        @{ Desc = 'Write-Host -NoNewline'; Code = "Write-Host '.' -NoNewline" }
        @{ Desc = 'Out-Host'; Code = "'widget' | Out-Host" }
        @{ Desc = 'Write-Progress'; Code = "Write-Progress -Activity 'widget'" }
        @{ Desc = 'Clear-Host'; Code = 'Clear-Host' }
        @{ Desc = 'cls alias'; Code = 'cls' }
        @{ Desc = '[Console]::Write'; Code = "[Console]::Write('.')" }
        @{ Desc = '[System.Console]::WriteLine'; Code = '[System.Console]::WriteLine()' }
        @{ Desc = '[Console]::Out.Write'; Code = "[Console]::Out.Write('widget')" }
        @{ Desc = '[Console]::Error.WriteLine'; Code = "[Console]::Error.WriteLine('gadget')" }
        @{ Desc = '[Console]::OpenStandardOutput'; Code = '$stream = [Console]::OpenStandardOutput()' }
        @{ Desc = 'a [Console] property assignment'; Code = "[Console]::Title = 'widget'" }
        @{ Desc = '$Host.UI.WriteLine'; Code = "`$Host.UI.WriteLine('widget')" }
        @{ Desc = '$Host.UI.WriteErrorLine'; Code = "`$Host.UI.WriteErrorLine('gadget')" }
        @{ Desc = 'a raw-UI property assignment'; Code = "`$Host.UI.RawUI.WindowTitle = 'widget'" }
        @{ Desc = 'a raw-UI mutator'; Code = '$Host.UI.RawUI.FlushInputBuffer()' }
    ) {
        Test-RawConsole $Code | Should -Not -BeNullOrEmpty
    }

    It 'passes what writes nothing to the console: <Desc>' -ForEach @(
        @{ Desc = 'Write-Message'; Code = "Write-Message 'widget'" }
        @{ Desc = 'an inline dot through the chokepoint'; Code = "Write-Message '.' -NoHeader -NoNewline" }
        @{ Desc = 'reading a [Console] property'; Code = '$left = [Console]::CursorLeft' }
        @{ Desc = 'reading the raw UI'; Code = '$size = $Host.UI.RawUI.WindowSize' }
        @{ Desc = 'saving and redirecting the console writer'; Code = "`$saved = [Console]::Out`n[Console]::SetOut(`$writer)" }
        @{ Desc = 'Write-Host named as an argument'; Code = 'Mock Write-Host { }' }
    ) {
        Test-RawConsole $Code | Should -BeNullOrEmpty
    }

    It 'reports one finding per console write' {
        Test-RawConsole "Write-Host 'widget'`n[Console]::Write('.')" | Should -HaveCount 2
    }
}
