Describe 'Get-FunctionDependency' -Tag 'L0', 'integrity' {
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
