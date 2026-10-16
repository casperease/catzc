<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.ModuleSystem
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/tests/Test-FunctionDependency.Tests.ps1.md
      source: automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
    adrs:
      - ADR-AUTO-TEST#35
---
#>

Describe 'Test-FunctionDependency' -Tag 'L1', 'integrity', 'source-only' {
    It 'the real repository dependency graph is satisfied' {
        $result = Test-FunctionDependency -PassThru -OutputFolder (Join-Path $TestDrive 'function-dependency')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'Test-FunctionDependency (fixture roots)' -Tag 'L0', 'logic', 'source-only' {
    BeforeAll {
        function New-FunctionFile {
            param([string]$Root, [string]$Module, [string]$Name, [switch]$Private, [string]$Body = '')
            $dir = Join-Path $Root $Module
            if ($Private) {
                $dir = Join-Path $dir 'private'
            }
            New-Item $dir -ItemType Directory -Force | Out-Null
            Set-Content (Join-Path $dir "$Name.ps1") "function $Name { $Body }"
        }
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:reportBase = Join-Path $TestDrive "reports-$([guid]::NewGuid().ToString('N'))"
    }

    It 'passes when every call resolves' -Tag 'ADR-AUTO-TEST#35' {
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-AThing' -Body 'Get-BThing; Write-Output 1'
        New-FunctionFile -Root $root -Module 'ModB' -Name 'Get-BThing'
        { Test-FunctionDependency -AutomationRoot $root -OutputFolder $reportBase } | Should -Not -Throw
    }

    It 'throws once listing every unresolved call and duplicate public function' -Tag 'ADR-AUTO-TEST#35' {
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-Dupe' -Body 'Get-NoSuchWidget'
        New-FunctionFile -Root $root -Module 'ModB' -Name 'Get-Dupe'
        $thrown = { Test-FunctionDependency -AutomationRoot $root -OutputFolder $reportBase } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-FunctionDependency failed: 2 issue(s)*'
        $message | Should -BeLike "*Duplicate public function 'Get-Dupe'*"
        $message | Should -BeLike '*Get-Dupe -> Get-NoSuchWidget (ModA/Get-Dupe.ps1:1)*'
    }

    It 'returns the result with the function count under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-AThing' -Body 'Get-NoSuchGadget'
        $result = Test-FunctionDependency -AutomationRoot $root -OutputFolder $reportBase -PassThru
        $result.Subject | Should -Be 'function-dependency'
        $result.IssueCount | Should -Be 1
        $result.FunctionCount | Should -Be 1
        Test-Path (Join-Path $result.ReportPath 'function-dependency.md') | Should -BeTrue
    }

    It 'allows the same private function name in two modules' {
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-AThing'
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-Shared' -Private
        New-FunctionFile -Root $root -Module 'ModB' -Name 'Get-BThing'
        New-FunctionFile -Root $root -Module 'ModB' -Name 'Get-Shared' -Private
        { Test-FunctionDependency -AutomationRoot $root -OutputFolder $reportBase } | Should -Not -Throw
    }
}

Describe 'Test-FunctionDependency — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Test-FunctionDependency -AutomationRoot $TestDrive } | Should -Throw '*Test-FunctionDependency operates on the catzc source tree*'
    }
}
