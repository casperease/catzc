Describe 'ConvertTo-SortedDictionary' -Tag 'L0', 'logic' {
    It 'preserves order of OrderedDictionary' {
        $source = [ordered]@{ z = 1; a = 2; m = 3 }
        $result = & (Get-Module Catzc.Base.Objects) { ConvertTo-SortedDictionary $args[0] } $source
        @($result.Keys) | Should -Be @('z', 'a', 'm')
    }

    It 'sorts keys of plain Hashtable' {
        $source = @{ z = 1; a = 2; m = 3 }
        $result = & (Get-Module Catzc.Base.Objects) { ConvertTo-SortedDictionary $args[0] } $source
        @($result.Keys) | Should -Be @('a', 'm', 'z')
    }

    It 'recursively processes nested dictionaries' {
        $source = @{ b = @{ z = 1; a = 2 }; a = 'leaf' }
        $result = & (Get-Module Catzc.Base.Objects) { ConvertTo-SortedDictionary $args[0] } $source
        @($result.Keys) | Should -Be @('a', 'b')
        @($result.b.Keys) | Should -Be @('a', 'z')
    }

    It 'returns an OrderedDictionary' {
        $source = @{ a = 1 }
        $result = & (Get-Module Catzc.Base.Objects) { ConvertTo-SortedDictionary $args[0] } $source
        $result | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
    }
}
