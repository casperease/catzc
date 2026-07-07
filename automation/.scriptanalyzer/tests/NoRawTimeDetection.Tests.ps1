# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
# ScriptBlockAst. The engine-wiring proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath)
# lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
Describe 'Measure-NoRawTimeDetection' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoRawTimeDetection.psm1') -Force
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-RawDetection {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoRawTimeDetection -ScriptBlockAst $ast
        }

        # The *.Tests.ps1 exemption keys off $ScriptBlockAst.Extent.File, so that case must parse from a real
        # file path (ParseInput leaves Extent.File empty).
        function Test-RawDetectionFile {
            param([string] $Code, [string] $FileName)
            $path = Join-Path $TestDrive $FileName
            Set-Content -Path $path -Value $Code
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            Measure-NoRawTimeDetection -ScriptBlockAst $ast
        }
    }

    It 'flags a direct read of the build-time flag outside the detector' {
        Test-RawDetection 'if ($env:CATZC_BUILD_TIME) { "building" }' | Should -Not -BeNullOrEmpty
    }

    It 'flags the build-time read inside a non-canonical function' {
        $code = @'
function Test-SomethingElse {
    [bool]$env:CATZC_BUILD_TIME
}
'@
        Test-RawDetection $code | Should -Not -BeNullOrEmpty
    }

    It 'exempts the canonical Test-IsBuildTime function' {
        $code = @'
function Test-IsBuildTime {
    [bool]$env:CATZC_BUILD_TIME
}
'@
        Test-RawDetection $code | Should -BeNullOrEmpty
    }

    It 'flags a Pester.psm1 call-frame sniff outside the detector' {
        Test-RawDetection '$f | Where-Object { $_.ScriptName -match "Pester.psm1" }' | Should -Not -BeNullOrEmpty
    }

    It 'exempts the canonical Test-IsTestTime function' {
        $code = @'
function Test-IsTestTime {
    Get-PSCallStack | Where-Object { $_.ScriptName -match 'Pester.psm1' }
}
'@
        Test-RawDetection $code | Should -BeNullOrEmpty
    }

    It 'passes clean code that calls the detector' {
        Test-RawDetection 'if ((Get-TimeBinding) -eq "test-time") { "under test" }' | Should -BeNullOrEmpty
    }

    It 'exempts *.Tests.ps1 files (test isolation set/restore and stack stubs)' {
        $code = @'
$env:CATZC_BUILD_TIME = 'true'
Mock Get-PSCallStack { @([pscustomobject]@{ ScriptName = 'Pester.psm1' }) }
'@
        Test-RawDetectionFile -Code $code -FileName 'Sample.Tests.ps1' | Should -BeNullOrEmpty
    }
}
