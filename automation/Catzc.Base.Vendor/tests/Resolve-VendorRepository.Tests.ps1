Describe 'Resolve-VendorRepository' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Vendor { }
        Mock Register-PSResourceRepository -ModuleName Catzc.Base.Vendor { }
    }

    It 'returns the configured source and registers nothing for the default (PSGallery, no url)' {
        Mock Get-Config -ModuleName Catzc.Base.Vendor { @{ source = 'PSGallery' } }
        $result = & (Get-Module Catzc.Base.Vendor) { Resolve-VendorRepository }
        $result | Should -Be 'PSGallery'
        Should -Invoke Register-PSResourceRepository -ModuleName Catzc.Base.Vendor -Times 0
    }

    It 'registers a custom source url under its name when not already registered' {
        Mock Get-Config -ModuleName Catzc.Base.Vendor { @{ source = 'MyFeed'; sourceUrl = 'https://feed/v3/index.json' } }
        Mock Get-PSResourceRepository -ModuleName Catzc.Base.Vendor { }
        $result = & (Get-Module Catzc.Base.Vendor) { Resolve-VendorRepository }
        $result | Should -Be 'MyFeed'
        Should -Invoke Register-PSResourceRepository -ModuleName Catzc.Base.Vendor -ParameterFilter {
            $Name -eq 'MyFeed' -and $Uri -eq 'https://feed/v3/index.json'
        }
    }

    It 'does not re-register a custom source that already exists' {
        Mock Get-Config -ModuleName Catzc.Base.Vendor { @{ source = 'MyFeed'; sourceUrl = 'https://feed/v3/index.json' } }
        Mock Get-PSResourceRepository -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ Name = 'MyFeed' } }
        & (Get-Module Catzc.Base.Vendor) { Resolve-VendorRepository } | Out-Null
        Should -Invoke Register-PSResourceRepository -ModuleName Catzc.Base.Vendor -Times 0
    }
}
