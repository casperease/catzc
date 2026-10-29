Describe 'Get-AzureNamePatternSet' -Tag 'L0', 'logic' {
    It 'defines the four patterns: long, kv, storage, vm' {
        $p = Get-AzureNamePatternSet
        foreach ($k in 'long', 'kv', 'storage', 'vm') {
            $p.Contains($k) | Should -BeTrue
        }
    }

    It 'long is hyphen-separated with no intrinsic limit (per-type)' {
        $long = (Get-AzureNamePatternSet).long
        $long.separator | Should -Be '-'
        $long.Contains('limit') | Should -BeFalse
    }

    It 'kv is hyphen-separated like long but length-restricted to 24' {
        $kv = (Get-AzureNamePatternSet).kv
        $kv.separator | Should -Be '-'
        $kv.limit | Should -Be 24
    }

    It 'storage is concatenated (no separator), capped at 24' {
        $storage = (Get-AzureNamePatternSet).storage
        $storage.separator | Should -Be ''
        $storage.limit | Should -Be 24
    }

    It 'vm uses the same tight (concatenated) render as storage, capped at 15 (Windows computer-name)' {
        $vm = (Get-AzureNamePatternSet).vm
        $vm.separator | Should -Be ''
        $vm.limit | Should -Be 15
    }

    It 'reads the resource-types config and returns a copy per call' {
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'resource-types' } {
            [Catzc.Azure.Templates.ResourceTypesConfig]::new([ordered]@{
                    patterns = [ordered]@{ wide = [ordered]@{ separator = '-' }; tight = [ordered]@{ separator = ''; limit = 12 } }
                    types    = [ordered]@{ cog = [ordered]@{ pattern = 'tight' } }
                })
        }
        $first = Get-AzureNamePatternSet
        @($first.Keys) | Should -Be @('wide', 'tight')
        $first.tight.limit = 1
        (Get-AzureNamePatternSet).tight.limit | Should -Be 12
    }
}
