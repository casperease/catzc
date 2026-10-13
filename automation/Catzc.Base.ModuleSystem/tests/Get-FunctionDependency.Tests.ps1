Describe 'Get-FunctionDependency' -Tag 'L0', 'integrity', 'source-only' {
    BeforeAll {
        $script:dependencies = Get-FunctionDependency
    }

    It 'CrossModule is true when CallerModule != TargetModule' {
        # One Should over the violating set — a Should per edge costs ~0.5ms × ~1000 cross-module edges,
        # which alone breaches the L0 time limit.
        $violations = foreach ($dependency in $dependencies) {
            if ($dependency.CrossModule -and $dependency.CallerModule -eq $dependency.TargetModule) {
                $dependency
            }
        }
        @($violations) | Should -BeNullOrEmpty
    }
}

Describe 'Get-FunctionDependency — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Get-FunctionDependency -AutomationRoot $TestDrive } | Should -Throw '*Get-FunctionDependency operates on the catzc source tree*'
    }
}
