# Real CLR types (PowerShell classes are genuine .NET types, parsed by PowerShell — no Roslyn compile) used to
# prove the reflect-over-public-members path with a nested typed member. Avoids Add-Type, whose Roslyn compile
# was the entire cost of this L0 file.
class CatzcFlatSettingSetDb {
    [string] $Host
    [int] $Port
}
class CatzcFlatSettingSetRoot {
    [string] $Name
    [CatzcFlatSettingSetDb] $Database
}

Describe 'ConvertTo-FlatSettingSet' -Tag 'L0', 'logic' {
    It 'flattens a simple nested object' {
        $object = [PSCustomObject]@{
            app = [PSCustomObject]@{
                name    = 'myapp'
                timeout = 30
            }
        }

        $result = $object | ConvertTo-FlatSettingSet

        $result | Should -BeOfType [System.Collections.Specialized.OrderedDictionary]
        $result['app.name'] | Should -Be 'myapp'
        $result['app.timeout'] | Should -Be 30
    }

    It 'flattens deeply nested objects' {
        $object = [PSCustomObject]@{
            a = [PSCustomObject]@{
                b = [PSCustomObject]@{
                    c = 'deep'
                }
            }
        }

        $result = ConvertTo-FlatSettingSet $object

        $result['a.b.c'] | Should -Be 'deep'
    }

    It 'handles arrays with index notation' {
        $object = [PSCustomObject]@{
            items = @('first', 'second', 'third')
        }

        $result = ConvertTo-FlatSettingSet $object

        $result['items[0]'] | Should -Be 'first'
        $result['items[1]'] | Should -Be 'second'
        $result['items[2]'] | Should -Be 'third'
    }

    It 'handles arrays of objects' {
        $object = [PSCustomObject]@{
            servers = @(
                [PSCustomObject]@{ name = 'web1' }
                [PSCustomObject]@{ name = 'web2' }
            )
        }

        $result = ConvertTo-FlatSettingSet $object

        $result['servers[0].name'] | Should -Be 'web1'
        $result['servers[1].name'] | Should -Be 'web2'
    }

    It 'stores null values as empty string' {
        $object = [PSCustomObject]@{
            present = 'yes'
            missing = $null
        }

        $result = ConvertTo-FlatSettingSet $object

        $result['present'] | Should -Be 'yes'
        $result['missing'] | Should -Be ''
    }

    It 'excludes intermediate PSCustomObject nodes' {
        $object = [PSCustomObject]@{
            parent = [PSCustomObject]@{
                leaf = 'value'
            }
        }

        $result = ConvertTo-FlatSettingSet $object

        $result.Keys | Should -Not -Contain 'parent'
        $result['parent.leaf'] | Should -Be 'value'
    }

    It 'handles hashtable values' {
        $object = [PSCustomObject]@{
            settings = @{ key = 'val' }
        }

        $result = ConvertTo-FlatSettingSet $object

        $result['settings.key'] | Should -Be 'val'
    }

    It 'respects MaxDepth' {
        $object = [PSCustomObject]@{
            a = [PSCustomObject]@{
                b = [PSCustomObject]@{
                    c = 'deep'
                }
            }
        }

        $result = ConvertTo-FlatSettingSet $object -MaxDepth 2

        $result.Keys | Should -Not -Contain 'a.b.c'
    }

    It 'processes multiple pipeline objects' {
        $objects = @(
            [PSCustomObject]@{ x = 1 }
            [PSCustomObject]@{ y = 2 }
        )

        $results = $objects | ConvertTo-FlatSettingSet

        $results.Count | Should -Be 2
        $results[0]['x'] | Should -Be 1
        $results[1]['y'] | Should -Be 2
    }

    It 'flattens a typed CLR object by reflecting over its public members' {
        $object = [CatzcFlatSettingSetRoot]::new()
        $object.Name = 'app'
        $object.Database = [CatzcFlatSettingSetDb]::new()
        $object.Database.Host = 'db1'
        $object.Database.Port = 5432

        $result = ConvertTo-FlatSettingSet $object

        $result['Name'] | Should -Be 'app'
        $result['Database.Host'] | Should -Be 'db1'
        $result['Database.Port'] | Should -Be 5432
    }

    It 'keeps value-type leaves (DateTime) intact rather than reflecting into them' {
        $stamp = [datetime]'2026-07-04T00:00:00'
        $object = [PSCustomObject]@{ when = $stamp }

        $result = ConvertTo-FlatSettingSet $object

        $result['when'] | Should -Be $stamp
        $result.Keys | Should -Not -Contain 'when.Year'
    }

    It 'roundtrips ConvertFrom-Json output' {
        $json = '{"database":{"host":"localhost","port":5432,"options":{"ssl":true}}}'
        $object = $json | ConvertFrom-Json

        $result = ConvertTo-FlatSettingSet $object

        $result['database.host'] | Should -Be 'localhost'
        $result['database.port'] | Should -Be 5432
        $result['database.options.ssl'] | Should -BeTrue
    }
}
