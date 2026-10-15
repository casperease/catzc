<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/Test-AnalyzedFileIsTest.Tests.ps1
    kind: test
---
#>

# Test-AnalyzedFileIsTest is the one test-file scope check the custom analyzer rules share: by file name when the
# analyzer reads a file (the gate), by Pester structure when it reads an editor buffer with no file name (VS Code).
Describe 'Test-AnalyzedFileIsTest' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/Test-AnalyzedFileIsTest.ps1')
        $script:fromFile = {
            param([string] $Name, [string] $Code)
            $path = Join-Path $TestDrive $Name
            [System.IO.Directory]::CreateDirectory((Split-Path $path -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($path, $Code)
            [System.Management.Automation.Language.Parser]::ParseFile($path, [ref] $null, [ref] $null)
        }
        $script:fromBuffer = {
            param([string] $Code)
            [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref] $null, [ref] $null)
        }
    }

    It 'decides by file name when the analyzer reads a file' {
        Test-AnalyzedFileIsTest -ScriptBlockAst (& $fromFile 'Widget.Tests.ps1' '$x = 1') | Should -BeTrue
        Test-AnalyzedFileIsTest -ScriptBlockAst (& $fromFile 'Widget.ps1' "Describe 'Widget' { }") | Should -BeFalse
    }

    It 'counts a file under a tests folder only when asked' {
        $ast = & $fromFile 'tests/Gadget.ps1' '$x = 1'
        Test-AnalyzedFileIsTest -ScriptBlockAst $ast | Should -BeFalse
        Test-AnalyzedFileIsTest -ScriptBlockAst $ast -IncludeTestsFolder | Should -BeTrue
    }

    It 'decides by Pester structure when an editor buffer has no file name' {
        Test-AnalyzedFileIsTest -ScriptBlockAst (& $fromBuffer "Describe 'Widget' { It 'works' { } }") | Should -BeTrue
        Test-AnalyzedFileIsTest -ScriptBlockAst (& $fromBuffer 'function Get-Widget { 1 }') | Should -BeFalse
    }

    It 'answers for the whole buffer from any nested block' {
        $root = & $fromBuffer "Describe 'Widget' { It 'works' { `$x = 1 } }"
        $nested = $root.Find({ param($node) $node -is [System.Management.Automation.Language.ScriptBlockAst] -and $node.Parent }, $true)
        Test-AnalyzedFileIsTest -ScriptBlockAst $nested | Should -BeTrue
    }
}
