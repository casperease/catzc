Describe 'Get-AzureResourceTypeSet' -Tag 'L0', 'logic' {
    It 'exposes the starter resource types' {
        $types = Get-AzureResourceTypeSet
        foreach ($t in 'rg', 'st', 'kv', 'waf', 'vnet') {
            $types.Contains($t) | Should -BeTrue
        }
    }

    It 'exposes the data/compute resource types (sql, sqldb, vm, synw, adf)' {
        $types = Get-AzureResourceTypeSet
        foreach ($t in 'sql', 'sqldb', 'vm', 'synw', 'adf') {
            $types.Contains($t) | Should -BeTrue
        }
    }

    It 'exposes the foundation/network resource types (log, nic, pip)' {
        $types = Get-AzureResourceTypeSet
        foreach ($t in 'log', 'nic', 'pip') {
            $types.Contains($t) | Should -BeTrue
        }
    }

    It 'vm omits org/customer/role from its render (so a slotted per-customer name fits 15)' {
        (Get-AzureResourceTypeSet).vm.omit | Should -Be @('org', 'customer', 'role')
    }

    It 'every type ties to a known pattern' {
        $types = Get-AzureResourceTypeSet
        $patterns = Get-AzureNamePatternSet
        foreach ($k in $types.Keys) {
            $patterns.Contains($types[$k].pattern) |
                Should -BeTrue -Because "type '$k' references pattern '$($types[$k].pattern)'"
        }
    }

    It 'every type abbreviation is 2-5 lowercase letters' {
        $types = Get-AzureResourceTypeSet
        foreach ($k in $types.Keys) {
            $k | Should -Match '^[a-z]{2,5}$'
        }
    }

    It 'only long-pattern types may use a 5-char abbreviation' {
        # The restricted storage/vm patterns can't spare the widened 5th char — derived from pattern,
        # not a flag.
        $types = Get-AzureResourceTypeSet
        foreach ($k in $types.Keys) {
            if ($types[$k].pattern -ne 'long') {
                $k.Length | Should -BeLessOrEqual 4 -Because "the '$($types[$k].pattern)' pattern keeps a 2-4 char abbreviation"
            }
        }
    }

    It 'long-pattern types carry their own limit; kv/storage/vm take it from the pattern' {
        $types = Get-AzureResourceTypeSet
        foreach ($k in $types.Keys) {
            if ($types[$k].pattern -eq 'long') {
                $types[$k].Contains('limit') | Should -BeTrue -Because "long type '$k' supplies its own limit"
            }
            else {
                $types[$k].Contains('limit') | Should -BeFalse -Because "restricted type '$k' inherits its limit from the pattern"
            }
        }
    }

    It 'rg is a long type with a 90-char limit' {
        $rg = (Get-AzureResourceTypeSet).rg
        $rg.pattern | Should -Be 'long'
        $rg.limit | Should -Be 90
    }

    It 'sqldb is a long type with a 128-char limit' {
        $sqldb = (Get-AzureResourceTypeSet).sqldb
        $sqldb.pattern | Should -Be 'long'
        $sqldb.limit | Should -Be 128
    }

    It 'key vault uses its own length-restricted kv pattern' {
        (Get-AzureResourceTypeSet).kv.pattern | Should -Be 'kv'
    }

    It 'storage account uses the storage pattern' {
        (Get-AzureResourceTypeSet).st.pattern | Should -Be 'storage'
    }

    It 'vm uses the vm pattern' {
        (Get-AzureResourceTypeSet).vm.pattern | Should -Be 'vm'
    }
}
