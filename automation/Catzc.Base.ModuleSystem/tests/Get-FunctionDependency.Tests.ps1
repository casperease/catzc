Describe 'Get-FunctionDependency' -Tag 'L0', 'integrity' {
    BeforeAll {
        $script:dependencies = Get-FunctionDependency
    }

    It 'CrossModule is true when CallerModule != TargetModule' {
        $dependencies | Where-Object CrossModule | ForEach-Object {
            $_.CallerModule | Should -Not -Be $_.TargetModule
        }
    }
}
