Describe 'JavaScriptTestResult' -Tag 'L0', 'logic' {
    It 'holds one case, its category logic unless its name starts with the integrity prefix' {
        $result = [Catzc.Base.Languages.JavaScriptTestResult]::new('nested/widget.test.js', 'claims a widget', 'pass', 0.5, $null)
        $result.Package | Should -Be 'nested/widget.test.js'
        $result.Output | Should -Be ''
        $result.Category | Should -Be 'logic'
        "$result" | Should -Be 'nested/widget.test.js claims a widget: pass'
        $prefix = [Catzc.Base.Languages.JavaScriptTestResult]::IntegrityPrefix
        ([Catzc.Base.Languages.JavaScriptTestResult]::new('widget.test.js', "$prefix ships", 'skip', 0, 'no package')).Category | Should -Be 'integrity'
    }

    It 'refuses a package, name, outcome or duration it cannot be' {
        { [Catzc.Base.Languages.JavaScriptTestResult]::new('widget.js', 'spins', 'pass', 0, '') } | Should -Throw '*Package*'
        { [Catzc.Base.Languages.JavaScriptTestResult]::new('nested\widget.test.js', 'spins', 'pass', 0, '') } | Should -Throw '*Package*'
        { [Catzc.Base.Languages.JavaScriptTestResult]::new('widget.test.js', ' spins', 'pass', 0, '') } | Should -Throw '*Name*'
        { [Catzc.Base.Languages.JavaScriptTestResult]::new('widget.test.js', 'spins', 'stalled', 0, '') } | Should -Throw '*Outcome*'
        { [Catzc.Base.Languages.JavaScriptTestResult]::new('widget.test.js', 'spins', 'pass', -1, '') } | Should -Throw '*DurationSeconds*'
    }
}
