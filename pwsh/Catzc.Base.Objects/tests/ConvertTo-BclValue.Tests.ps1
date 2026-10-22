Describe 'ConvertTo-BclValue' -Tag 'L0', 'logic' {
    BeforeAll {
        # Pipeline output wraps each value in a PSObject, the way a pwsh caller's array holds them.
        $script:wrapped = { param($Value) Write-Output $Value }
    }

    It 'returns a scalar as its base value, and null and a string unchanged' {
        $value = & $script:wrapped 7
        $value -is [psobject] | Should -BeTrue
        $result = ConvertTo-BclValue $value
        $result | Should -Be 7
        $result -is [psobject] | Should -BeFalse
        ConvertTo-BclValue $null | Should -BeNullOrEmpty
        ConvertTo-BclValue 'widget' | Should -BeExactly 'widget'
    }

    It 'unwraps every element of nested lists and keeps an array an array' {
        $inner = @('gadget', 'sprocket' | ForEach-Object { $_ })
        $list = [System.Collections.Generic.List[object]]::new()
        $list.Add('cog')
        $array = [object[]]@((& $script:wrapped 'widget'), $inner, $list)
        $array[0] -is [psobject] | Should -BeTrue
        $inner[0] -is [psobject] | Should -BeTrue

        $result = ConvertTo-BclValue $array
        , $result | Should -BeOfType [object[]]
        $result[0] -is [psobject] | Should -BeFalse
        $result[0] | Should -BeExactly 'widget'
        , $result[1] | Should -BeOfType [object[]]
        $result[1][0] -is [psobject] | Should -BeFalse
        , $result[2] | Should -BeOfType ([System.Collections.Generic.List[object]])
        $inner[0] -is [psobject] | Should -BeTrue -Because 'the caller''s array is never changed'
    }

    It 'unwraps the values of nested dictionaries, keeping their order and their key comparer' {
        $table = @{ Widget = (& $script:wrapped 1) }
        $ordered = [ordered]@{ gadget = (& $script:wrapped 2); widget = [object[]]@((& $script:wrapped 3)); table = $table }

        $result = ConvertTo-BclValue $ordered
        , $result | Should -BeOfType ([System.Collections.Specialized.OrderedDictionary])
        @($result.Keys) | Should -Be @('gadget', 'widget', 'table')
        $result['gadget'] -is [psobject] | Should -BeFalse
        $result['widget'][0] -is [psobject] | Should -BeFalse
        $result['table']['widget'] | Should -Be 1 -Because 'a hashtable keeps its case-insensitive comparer'
        $result['table']['Widget'] -is [psobject] | Should -BeFalse
        $table['Widget'] -is [psobject] | Should -BeTrue -Because 'the caller''s table is never changed'
    }
}
