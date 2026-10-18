Describe 'ConvertTo-Dictionary' -Tag 'L0', 'logic' {
    It 'converts a typed class into a mutable nested ordered dictionary' {
        $result = [Catzc.Base.Execution.CliResult]::new("hello`r`n", 'oops', 3)
        $dict = ConvertTo-Dictionary $result
        $dict | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
        $dict['Output'] | Should -Be 'hello'
        $dict['ExitCode'] | Should -Be 3
        # The dict is a fresh, mutable copy — assigning does not throw and does not touch the source.
        $dict['Output'] = 'changed'
        $result.Output | Should -Be 'hello'
    }

    It 'recurses into a nested typed object' {
        $nested = [PSCustomObject]@{ name = 'x'; inner = [Catzc.Base.Execution.CliResult]::new('o', '', 0) }
        $dict = ConvertTo-Dictionary $nested
        $dict['inner'] | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
        $dict['inner']['Output'] | Should -Be 'o'
    }

    It 'passes a dictionary through as a fresh nested ordered dictionary' {
        $src = [ordered]@{ a = 1; b = @{ c = 2 } }
        $dict = ConvertTo-Dictionary $src
        $dict['a'] | Should -Be 1
        $dict['b']['c'] | Should -Be 2
    }

    It '-AsPSObject emits nested PSCustomObjects' {
        $result = [Catzc.Base.Execution.CliResult]::new('o', '', 0)
        $customObject = ConvertTo-Dictionary $result -AsPSObject
        $customObject | Should -BeOfType [PSCustomObject]
        $customObject.Output | Should -Be 'o'
    }
}
