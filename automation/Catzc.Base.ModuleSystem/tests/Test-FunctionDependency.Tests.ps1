# The integrity invariant — the real repository's function dependency graph is satisfied — needs exactly one
# scan of the real automation tree. The [bool] return contract is pure logic, so it is proven at L0 against a
# fixture root rather than by a second full-tree scan.
Describe 'Test-FunctionDependency' -Tag 'L1', 'integrity', 'source-only' {
    It 'the real repository dependency graph is satisfied' {
        # -BeTrue also confirms the return is a truthy [bool]; the type contract itself is covered at L0 below.
        Test-FunctionDependency | Should -BeTrue
    }
}

Describe 'Test-FunctionDependency (fixture roots)' -Tag 'L0', 'logic', 'source-only' {
    BeforeAll {
        function New-FunctionFile {
            param([string]$Root, [string]$Module, [string]$Name, [switch]$Private)
            $dir = Join-Path $Root $Module
            if ($Private) {
                $dir = Join-Path $dir 'private'
            }
            New-Item $dir -ItemType Directory -Force | Out-Null
            Set-Content (Join-Path $dir "$Name.ps1") "function $Name { }"
        }
    }

    It 'returns a boolean' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-AThing'
        Test-FunctionDependency -AutomationRoot $root | Should -BeOfType [bool]
    }

    It 'throws when two modules define the same public function' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-Dupe'
        New-FunctionFile -Root $root -Module 'ModB' -Name 'Get-Dupe'
        { Test-FunctionDependency -AutomationRoot $root } |
            Should -Throw -ExpectedMessage "*Duplicate public function 'Get-Dupe'*"
    }

    It 'allows the same private function name in two modules' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-AThing'
        New-FunctionFile -Root $root -Module 'ModA' -Name 'Get-Shared' -Private
        New-FunctionFile -Root $root -Module 'ModB' -Name 'Get-BThing'
        New-FunctionFile -Root $root -Module 'ModB' -Name 'Get-Shared' -Private
        { Test-FunctionDependency -AutomationRoot $root } | Should -Not -Throw
    }
}

Describe 'Test-FunctionDependency — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Test-FunctionDependency -AutomationRoot $TestDrive } | Should -Throw '*Test-FunctionDependency operates on the catzc source tree*'
    }
}
