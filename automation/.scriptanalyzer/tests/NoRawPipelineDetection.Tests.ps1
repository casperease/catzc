Describe 'Measure-NoRawPipelineDetection' -Tag 'L2', 'logic' {
    BeforeAll {
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }
        $script:rulePath = Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoRawPipelineDetection.psm1'

        function Test-RawDetection {
            param([string] $Code)
            Invoke-ScriptAnalyzer -ScriptDefinition $Code -CustomRulePath $script:rulePath |
                Where-Object RuleName -EQ 'Measure-NoRawPipelineDetection'
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
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ('rawdet-' + [guid]::NewGuid())
        New-Item -Path $tempDir -ItemType Directory | Out-Null
        try {
            $testFile = Join-Path $tempDir 'Sample.Tests.ps1'
            Set-Content -Path $testFile -Value @'
$orig = $env:TF_BUILD
try { $env:TF_BUILD = 'True' } finally { $env:TF_BUILD = $orig }
'@
            $result = Invoke-ScriptAnalyzer -Path $testFile -CustomRulePath $script:rulePath |
                Where-Object RuleName -EQ 'Measure-NoRawPipelineDetection'
            $result | Should -BeNullOrEmpty
        }
        finally {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
