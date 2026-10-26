Describe 'ConvertTo-YamlSafe' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:module = Get-Module Catzc.Base.Objects
    }

    It 'passes through null' {
        $result = & $module { ConvertTo-YamlSafe -Value $null }
        $result | Should -BeNullOrEmpty
    }

    It 'passes through strings' {
        $result = & $module { ConvertTo-YamlSafe -Value 'hello' }
        $result | Should -Be 'hello'
    }

    It 'passes through value types' {
        (& $module { ConvertTo-YamlSafe -Value 42 }) | Should -Be 42
        (& $module { ConvertTo-YamlSafe -Value $true }) | Should -BeTrue
        (& $module { ConvertTo-YamlSafe -Value 3.14 }) | Should -Be 3.14
    }

    It 'converts PSCustomObject to ordered dictionary' {
        $result = & $module { ConvertTo-YamlSafe -Value ([PSCustomObject]@{ A = 1; B = 'two' }) }

        $result | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
        $result['A'] | Should -Be 1
        $result['B'] | Should -Be 'two'
    }

    It 'converts hashtable to ordered dictionary' {
        $result = & $module { ConvertTo-YamlSafe -Value @{ X = 10 } }

        $result | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
        $result['X'] | Should -Be 10
    }

    It 'converts arrays and preserves items' {
        $result = & $module { ConvertTo-YamlSafe -Value @('a', 'b', 'c') }

        $result | Should -HaveCount 3
        $result[0] | Should -Be 'a'
    }

    It 'recurses nested PSCustomObjects' {
        $object = [PSCustomObject]@{
            L1 = [PSCustomObject]@{
                L2 = [PSCustomObject]@{
                    L3 = 'deep'
                }
            }
        }

        $result = & $module { ConvertTo-YamlSafe -Value $args[0] } $object

        $result['L1'] | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
        $result['L1']['L2'] | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
        $result['L1']['L2']['L3'] | Should -Be 'deep'
    }

    It 'recurses arrays of objects' {
        $arr = @(
            [PSCustomObject]@{ Name = 'a' }
            [PSCustomObject]@{ Name = 'b' }
        )

        $result = & $module { ConvertTo-YamlSafe -Value $args[0] } $arr

        $result | Should -HaveCount 2
        $result[0]['Name'] | Should -Be 'a'
        $result[1]['Name'] | Should -Be 'b'
    }

    It 'recurses nested dictionaries' {
        $ht = @{
            Outer = @{
                Inner = 'val'
            }
        }

        $result = & $module { ConvertTo-YamlSafe -Value $args[0] } $ht

        $result['Outer'] | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
        $result['Outer']['Inner'] | Should -Be 'val'
    }

    It 'handles mixed-type arrays with nested objects' {
        $arr = @(
            'text'
            42
            [PSCustomObject]@{
                Inner = [PSCustomObject]@{
                    Deep = [PSCustomObject]@{ Leaf = $true }
                }
            }
        )

        $result = & $module { ConvertTo-YamlSafe -Value $args[0] } $arr

        $result[0] | Should -Be 'text'
        $result[1] | Should -Be 42
        $result[2]['Inner']['Deep']['Leaf'] | Should -BeTrue
    }

    It 'respects MaxDepth and stringifies beyond limit' {
        $object = [PSCustomObject]@{
            A = [PSCustomObject]@{
                B = [PSCustomObject]@{
                    C = 'too deep'
                }
            }
        }

        $result = & $module { ConvertTo-YamlSafe -Value $args[0] -MaxDepth 2 } $object

        $result['A']['B'] | Should -BeOfType [string]
    }

    It 'returns not-rendered for property that throws on access' {
        $object = [PSCustomObject]@{ Good = 'ok' }
        $object | Add-Member -MemberType ScriptProperty -Name Bad -Value { throw 'nope' }

        $result = & $module { ConvertTo-YamlSafe -Value $args[0] } $object

        $result['Good'] | Should -Be 'ok'
        $result['Bad'] | Should -Be '[not rendered]'
    }

    It 'returns not-rendered string when ToString throws at max depth' {
        $object = [PSCustomObject]@{ X = 1 }
        $object | Add-Member -MemberType ScriptMethod -Name ToString -Value { throw 'nope' } -Force

        $result = & $module { ConvertTo-YamlSafe -Value $args[0] -MaxDepth 0 } $object

        $result | Should -Be '[not rendered]'
    }

    It 'handles ErrorRecord without throwing' {
        $err = try {
            throw 'boom'
        }
        catch {
            $_
        }

        $result = & $module { ConvertTo-YamlSafe -Value $args[0] } $err

        $result | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
    }

    It 'produces clean YAML without @{ artifacts' {
        $object = [PSCustomObject]@{
            Name   = 'svc'
            Health = [PSCustomObject]@{
                Status = 'OK'
                Checks = [PSCustomObject]@{
                    DB    = 'OK'
                    Cache = 'Degraded'
                }
            }
        }

        $yaml = (& $module { ConvertTo-YamlSafe $args[0] | ConvertTo-Yaml } $object).TrimEnd()

        $yaml | Should -Match 'Name: svc'
        $yaml | Should -Match 'Status: OK'
        $yaml | Should -Match 'DB: OK'
        $yaml | Should -Match 'Cache: Degraded'
        $yaml | Should -Not -Match '@\{'
    }
}
