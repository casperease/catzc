# cspell:ignore alweutstsmplst weuwkspvm sttstsmplalweu alweusmplvm vmsmplalweu weutstsmplst
Describe 'Get-AzureResourceName' -Tag 'L0', 'logic' {
    It 'renders the env NAME for a generous (long) type' {
        Get-AzureResourceName -Env alpha -Slot 001 -RegionCode weu -Org tst -ShortName smpl -Type rg |
            Should -Be 'alpha-001-weu-tst-smpl-rg'
    }

    It 'drops the slot segment for a base slot' {
        Get-AzureResourceName -Env alpha -RegionCode weu -Org tst -ShortName smpl -Type rg |
            Should -Be 'alpha-weu-tst-smpl-rg'
    }

    It 'renders the SHORTCODE (tight, concatenated) for a storage account' {
        Get-AzureResourceName -Env alpha -Shortcode al -Slot 001 -RegionCode weu -Org tst -ShortName smpl -Type st |
            Should -Be 'al001weutstsmplst'
    }

    It 'renders the SHORTCODE for kv (hyphenated but restricted-budget)' {
        Get-AzureResourceName -Env alpha -Shortcode al -RegionCode weu -Org tst -ShortName smpl -Type kv |
            Should -Be 'al-weu-tst-smpl-kv'
    }

    It 'inserts customer and role (long)' {
        Get-AzureResourceName -Env alpha -RegionCode weu -Org tst -ShortName smpl -Customer acme -Role hot -Type rg |
            Should -Be 'alpha-weu-tst-smpl-acme-hot-rg'
    }

    It 'throws when a restricted type is given no shortcode' {
        { Get-AzureResourceName -Env alpha -RegionCode weu -Org tst -ShortName smpl -Type st } |
            Should -Throw '*needs a -Shortcode*'
    }

    It 'throws on an unknown name order' {
        { Get-AzureResourceName -Env alpha -RegionCode weu -Org tst -ShortName smpl -Type rg -Order bogus } |
            Should -Throw '*Unknown name order*'
    }

    It 'throws on an unknown resource type' {
        { Get-AzureResourceName -Env alpha -RegionCode weu -Org tst -ShortName smpl -Type zzz } |
            Should -Throw '*Unknown resource type*'
    }

    It 'throws on an invalid component (region not 3 letters)' {
        { Get-AzureResourceName -Env alpha -RegionCode westeurope -Org tst -ShortName smpl -Type rg } |
            Should -Throw '*Invalid RegionCode*'
    }

    It 'throws when the rendered name exceeds the type limit (kv)' {
        { Get-AzureResourceName -Env gamma -Shortcode gm -Slot 001 -RegionCode weu -Org abc -ShortName discw -Customer acme -CustomerShortcode ac -Role hot -Type kv } |
            Should -Throw '*exceeds*limit*'
    }

    It 'vm omits org/customer/role (RG-encoded) and fits 15 for a slotted per-customer name' {
        $name = Get-AzureResourceName -Env alpha -Shortcode al -Slot 001 -RegionCode weu -Org tst -ShortName wksp -Customer acme -CustomerShortcode ac -Role hot -Type vm
        $name | Should -Be 'al001weuwkspvm'
        $name.Length | Should -BeLessOrEqual 15
    }

    It 'vm does not require a CustomerShortcode (customer is omitted from its render)' {
        { Get-AzureResourceName -Env alpha -Shortcode al -RegionCode weu -Org tst -ShortName smpl -Customer acme -Type vm } |
            Should -Not -Throw
    }

    It 'renders a long Log Analytics name (env name + customer key)' {
        Get-AzureResourceName -Env alpha -RegionCode weu -Org tst -ShortName fnd -Customer acme -Type log |
            Should -Be 'alpha-weu-tst-fnd-acme-log'
    }

    Context 'the render matrix — 4 patterns x 2 orders (env alpha / shortcode al, base slot)' {
        # The pattern selects the env-segment (long → name, restricted → shortcode) and the separator
        # (hyphen for long/kv, none for storage/vm); the order arranges the segments. Base slot, so the
        # slot segment is dropped.
        BeforeAll {
            $script:parts = @{ Env = 'alpha'; Shortcode = 'al'; RegionCode = 'weu'; Org = 'tst'; ShortName = 'smpl' }
        }

        It 'long / standard' { Get-AzureResourceName @parts -Type rg                | Should -Be 'alpha-weu-tst-smpl-rg' }
        It 'long / classic' { Get-AzureResourceName @parts -Type rg -Order classic | Should -Be 'rg-tst-smpl-alpha-weu' }
        It 'kv / standard' { Get-AzureResourceName @parts -Type kv                | Should -Be 'al-weu-tst-smpl-kv' }
        It 'kv / classic' { Get-AzureResourceName @parts -Type kv -Order classic | Should -Be 'kv-tst-smpl-al-weu' }
        It 'storage / standard' { Get-AzureResourceName @parts -Type st                | Should -Be 'alweutstsmplst' }
        It 'storage / classic' { Get-AzureResourceName @parts -Type st -Order classic | Should -Be 'sttstsmplalweu' }
        It 'vm / standard' { Get-AzureResourceName @parts -Type vm                | Should -Be 'alweusmplvm' }
        It 'vm / classic' { Get-AzureResourceName @parts -Type vm -Order classic | Should -Be 'vmsmplalweu' }
    }
}
