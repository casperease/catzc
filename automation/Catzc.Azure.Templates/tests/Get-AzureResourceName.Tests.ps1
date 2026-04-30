# cspell:ignore weuzctsmplst weuwkspvm deweuzctsmplst stzctsmpldeweu deweusmplvm
Describe 'Get-AzureResourceName' -Tag 'L0', 'logic' {
    It 'renders the env NAME for a generous (long) type' {
        Get-AzureResourceName -Env develop -Slot 001 -RegionCode weu -Org zct -ShortName smpl -Type rg |
            Should -Be 'develop-001-weu-zct-smpl-rg'
    }

    It 'drops the slot segment for a base slot' {
        Get-AzureResourceName -Env develop -RegionCode weu -Org zct -ShortName smpl -Type rg |
            Should -Be 'develop-weu-zct-smpl-rg'
    }

    It 'renders the SHORTCODE (tight, concatenated) for a storage account' {
        Get-AzureResourceName -Env develop -Shortcode de -Slot 001 -RegionCode weu -Org zct -ShortName smpl -Type st |
            Should -Be 'de001weuzctsmplst'
    }

    It 'renders the SHORTCODE for kv (hyphenated but restricted-budget)' {
        Get-AzureResourceName -Env develop -Shortcode de -RegionCode weu -Org zct -ShortName smpl -Type kv |
            Should -Be 'de-weu-zct-smpl-kv'
    }

    It 'inserts customer and role (long)' {
        Get-AzureResourceName -Env develop -RegionCode weu -Org zct -ShortName smpl -Customer acme -Role hot -Type rg |
            Should -Be 'develop-weu-zct-smpl-acme-hot-rg'
    }

    It 'throws when a restricted type is given no shortcode' {
        { Get-AzureResourceName -Env develop -RegionCode weu -Org zct -ShortName smpl -Type st } |
            Should -Throw '*needs a -Shortcode*'
    }

    It 'throws on an unknown name order' {
        { Get-AzureResourceName -Env develop -RegionCode weu -Org zct -ShortName smpl -Type rg -Order bogus } |
            Should -Throw '*Unknown name order*'
    }

    It 'throws on an unknown resource type' {
        { Get-AzureResourceName -Env develop -RegionCode weu -Org zct -ShortName smpl -Type zzz } |
            Should -Throw '*Unknown resource type*'
    }

    It 'throws on an invalid component (region not 3 letters)' {
        { Get-AzureResourceName -Env develop -RegionCode westeurope -Org zct -ShortName smpl -Type rg } |
            Should -Throw '*Invalid RegionCode*'
    }

    It 'throws when the rendered name exceeds the type limit (kv)' {
        { Get-AzureResourceName -Env prod -Shortcode pr -Slot 001 -RegionCode weu -Org abc -ShortName discw -Customer acme -CustomerShortcode ac -Role hot -Type kv } |
            Should -Throw '*exceeds*limit*'
    }

    It 'vm omits org/customer/role (RG-encoded) and fits 15 for a slotted per-customer name' {
        $name = Get-AzureResourceName -Env develop -Shortcode de -Slot 001 -RegionCode weu -Org zct -ShortName wksp -Customer apex -CustomerShortcode ap -Role hot -Type vm
        $name | Should -Be 'de001weuwkspvm'
        $name.Length | Should -BeLessOrEqual 15
    }

    It 'vm does not require a CustomerShortcode (customer is omitted from its render)' {
        { Get-AzureResourceName -Env develop -Shortcode de -RegionCode weu -Org zct -ShortName smpl -Customer apex -Type vm } |
            Should -Not -Throw
    }

    It 'renders a long Log Analytics name (env name + customer key)' {
        Get-AzureResourceName -Env develop -RegionCode weu -Org zct -ShortName fnd -Customer apex -Type log |
            Should -Be 'develop-weu-zct-fnd-apex-log'
    }

    Context 'the render matrix — 4 patterns x 2 orders (env develop / shortcode de, base slot)' {
        # The pattern selects the env-segment (long → name, restricted → shortcode) and the separator
        # (hyphen for long/kv, none for storage/vm); the order arranges the segments. Base slot, so the
        # slot segment is dropped.
        BeforeAll {
            $script:dev = @{ Env = 'develop'; Shortcode = 'de'; RegionCode = 'weu'; Org = 'zct'; ShortName = 'smpl' }
        }

        It 'long / standard' { Get-AzureResourceName @dev -Type rg                | Should -Be 'develop-weu-zct-smpl-rg' }
        It 'long / classic' { Get-AzureResourceName @dev -Type rg -Order classic | Should -Be 'rg-zct-smpl-develop-weu' }
        It 'kv / standard' { Get-AzureResourceName @dev -Type kv                | Should -Be 'de-weu-zct-smpl-kv' }
        It 'kv / classic' { Get-AzureResourceName @dev -Type kv -Order classic | Should -Be 'kv-zct-smpl-de-weu' }
        It 'storage / standard' { Get-AzureResourceName @dev -Type st                | Should -Be 'deweuzctsmplst' }
        It 'storage / classic' { Get-AzureResourceName @dev -Type st -Order classic | Should -Be 'stzctsmpldeweu' }
        It 'vm / standard' { Get-AzureResourceName @dev -Type vm                | Should -Be 'deweusmplvm' }
        It 'vm / classic' { Get-AzureResourceName @dev -Type vm -Order classic | Should -Be 'vmsmpldeweu' }
    }
}
