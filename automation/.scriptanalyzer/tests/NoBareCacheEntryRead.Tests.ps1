<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/NoBareCacheEntryRead.Tests.ps1
    kind: test
---
#>

# The per-case assertions run the rule function directly on a parsed AST (L0). The engine-wiring proof lives once,
# for all custom rules, in CustomRuleWiring.Tests.ps1.
Describe 'Measure-NoBareCacheEntryRead' -Tag 'L0', 'logic', 'ADR-PWSH-CACHE#4' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoBareCacheEntryRead.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly.
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-CacheEntryRead {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoBareCacheEntryRead -ScriptBlockAst $ast
        }

        function Test-CacheEntryReadInFile {
            param([string] $Name, [string] $Code)
            $path = Join-Path $TestDrive $Name
            [System.IO.File]::WriteAllText($path, $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            Measure-NoBareCacheEntryRead -ScriptBlockAst $ast
        }
    }

    It 'flags a lazy cache entry read before anything sets it: <Case>' -ForEach @(
        @{ Case = 'truthiness check'; Code = 'function Get-Widget { if (-not $script:widgetCache) { $script:widgetCache = @{} }; $script:widgetCache }' }
        @{ Case = 'null comparison'; Code = 'function Get-Widget { if ($null -ne $script:widgetCache) { return $script:widgetCache } }' }
        @{ Case = 'coalescing assignment'; Code = 'function Get-Widget { $script:widgetCache ??= @{} }' }
    ) {
        $records = @(Test-CacheEntryRead $Code)
        $records.Count | Should -BeGreaterThan 0
        $records[0].RuleName | Should -Be 'Measure-NoBareCacheEntryRead'
    }

    It 'accepts a cache entry probed with GetValue, then read' {
        $code = @'
function Get-Widget {
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:widgetCache')) {
        $script:widgetCache = @{}
    }
    $script:widgetCache
}
'@
        Test-CacheEntryRead $code | Should -BeNullOrEmpty
    }

    It 'accepts a read after the function assigns the cache entry' {
        Test-CacheEntryRead 'function Reset-Widget { $script:widgetCache = @{}; $script:widgetCache.Count }' | Should -BeNullOrEmpty
    }

    It 'leaves a .psm1 alone: it can declare its cache entries at load' {
        Test-CacheEntryReadInFile 'Gadget.psm1' 'function Get-Gadget { $script:gadgetCache }' | Should -BeNullOrEmpty
    }

    It 'accepts a cache entry the script declares at top level, even with no file name (an editor buffer)' {
        $code = @'
$script:gadgetCache = @{}
function Get-Gadget { $script:gadgetCache }
'@
        Test-CacheEntryRead $code | Should -BeNullOrEmpty
    }

    It 'leaves a Pester file alone: it shares state through $script: on purpose' {
        Test-CacheEntryReadInFile 'Get-Gadget.Tests.ps1' 'function Get-Gadget { $script:gadgetCache }' | Should -BeNullOrEmpty
    }

    It 'checks a function file' {
        @(Test-CacheEntryReadInFile 'Get-Gadget.ps1' 'function Get-Gadget { $script:gadgetCache }') | Should -HaveCount 1
    }
}
