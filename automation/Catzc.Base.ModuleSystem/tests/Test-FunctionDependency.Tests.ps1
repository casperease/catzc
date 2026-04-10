Describe 'Test-FunctionDependency' -Tag 'L1', 'integrity' {
    It 'returns a boolean' {
        $result = Test-FunctionDependency
        $result | Should -BeOfType [bool]
    }

    It 'returns true when all dependencies are satisfied' {
        Test-FunctionDependency | Should -BeTrue
    }
}

Describe 'Test-FunctionDependency (fixture roots)' -Tag 'L0', 'logic' {
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
