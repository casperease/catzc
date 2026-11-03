Describe 'Resolve-VendorRepository' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Vendor { }
        Mock Register-PSResourceRepository -ModuleName Catzc.Base.Vendor { }
    }

    It 'returns the default source name and registers nothing while that repository exists' {
        Mock Get-Config -ModuleName Catzc.Base.Vendor { [Catzc.Base.Vendor.VendorConfig]::new(@{}) }
        Mock Get-PSResourceRepository -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ Name = 'PSGallery' } }
        $result = & (Get-Module Catzc.Base.Vendor) { Resolve-VendorRepository }
        $result | Should -Be 'psgallery'
        Should -Invoke Register-PSResourceRepository -ModuleName Catzc.Base.Vendor -Times 0
    }

    It 'registers a custom source url under its name when not already registered' {
        Mock Get-Config -ModuleName Catzc.Base.Vendor { [Catzc.Base.Vendor.VendorConfig]::new(@{ package_source = @{ name = 'widgetfeed'; url = 'https://feed.widget.test/v3/index.json' } }) }
        Mock Get-PSResourceRepository -ModuleName Catzc.Base.Vendor { }
        $result = & (Get-Module Catzc.Base.Vendor) { Resolve-VendorRepository }
        $result | Should -Be 'widgetfeed'
        Should -Invoke Register-PSResourceRepository -ModuleName Catzc.Base.Vendor -ParameterFilter {
            $Name -eq 'widgetfeed' -and $Uri -eq 'https://feed.widget.test/v3/index.json'
        }
    }

    It 'does not re-register a custom source that already exists' {
        Mock Get-Config -ModuleName Catzc.Base.Vendor { [Catzc.Base.Vendor.VendorConfig]::new(@{ package_source = @{ name = 'widgetfeed'; url = 'https://feed.widget.test/v3/index.json' } }) }
        Mock Get-PSResourceRepository -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ Name = 'widgetfeed' } }
        & (Get-Module Catzc.Base.Vendor) { Resolve-VendorRepository } | Out-Null
        Should -Invoke Register-PSResourceRepository -ModuleName Catzc.Base.Vendor -Times 0
    }
}
