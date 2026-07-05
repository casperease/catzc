# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
# ScriptBlockAst. The engine-wiring proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath)
# lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
Describe 'Measure-NoRawPipelineDetection' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoRawPipelineDetection.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
        # once for the type — we never invoke the analyzer engine (that is the L2 wiring test below).
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-RawDetection {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoRawPipelineDetection -ScriptBlockAst $ast
        }

        # The *.Tests.ps1 exemption keys off $ScriptBlockAst.Extent.File, so that case must parse from a real
        # file path (ParseInput leaves Extent.File empty).
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
