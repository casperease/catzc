<#
---
catzc:
  immutable:
    with_body_sha: "78cf3019d320"
  edges:
    docs: "[NoRawPipelineDetection.Tests.ps1.md](docs/references/pwsh/scriptanalyzer/tests/NoRawPipelineDetection.Tests.ps1.md)"
---
#>

Describe 'Measure-NoRawPipelineDetection' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/NoRawPipelineDetection.psm1') -Force
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
        }

        function Test-RawDetection {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoRawPipelineDetection -ScriptBlockAst $ast
        }

        function Test-RawDetectionFile {
            param([string] $Code, [string] $FileName)
            $path = Join-Path $TestDrive $FileName
            Set-Content -Path $path -Value $Code
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            Measure-NoRawPipelineDetection -ScriptBlockAst $ast
        }
    }

    It 'flags a direct read of <Var> outside the detector' -ForEach @(
        @{ Var = '$env:TF_BUILD' }
        @{ Var = '$env:GITHUB_ACTIONS' }
    ) {
        Test-RawDetection "if ($Var) { 'in CI' }" | Should -Not -BeNullOrEmpty
    }

    It 'flags the read inside a non-canonical function' {
        $code = @'
function Test-SomethingElse {
    [bool]$env:TF_BUILD
}
'@
        Test-RawDetection $code | Should -Not -BeNullOrEmpty
    }

    It 'exempts the canonical Test-IsRunningInPipeline function' {
        $code = @'
function Test-IsRunningInPipeline {
    [bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS
}
'@
        Test-RawDetection $code | Should -BeNullOrEmpty
    }

    It 'flags a direct read of $env:TERM_PROGRAM outside the VS Code detector, naming that detector' {
        $finding = Test-RawDetection "if (`$env:TERM_PROGRAM -eq 'vscode') { 'editor' }"
        $finding | Should -Not -BeNullOrEmpty
        $finding.Message | Should -BeLike '*Call Test-IsRunningInVsCode*'
    }

    It 'exempts the canonical Test-IsRunningInVsCode function, and only for its own variable' {
        $code = @'
function Test-IsRunningInVsCode {
    $env:TERM_PROGRAM -eq 'vscode'
}
'@
        Test-RawDetection $code | Should -BeNullOrEmpty
        $crossed = @'
function Test-IsRunningInVsCode {
    [bool]$env:TF_BUILD
}
'@
        Test-RawDetection $crossed | Should -Not -BeNullOrEmpty
    }

    It 'does not flag the output-path variable BUILD_ARTIFACTSTAGINGDIRECTORY' {
        Test-RawDetection '$env:BUILD_ARTIFACTSTAGINGDIRECTORY' | Should -BeNullOrEmpty
    }

    It 'passes clean code that calls the detector' {
        Test-RawDetection 'if (Test-IsRunningInPipeline) { "ci" }' | Should -BeNullOrEmpty
    }

    It 'exempts *.Tests.ps1 files (test isolation set/restore)' {
        $code = @'
$orig = $env:TF_BUILD
try { $env:TF_BUILD = 'True' } finally { $env:TF_BUILD = $orig }
'@
        Test-RawDetectionFile -Code $code -FileName 'Sample.Tests.ps1' | Should -BeNullOrEmpty
    }
}
