Describe 'Install-VendorModule' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Vendor { }
        Mock Resolve-VendorRepository -ModuleName Catzc.Base.Vendor { 'PSGallery' }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Vendor { 'TestDrive:' }
        Mock Test-Path -ModuleName Catzc.Base.Vendor { $true }
        Mock Save-PSResource -ModuleName Catzc.Base.Vendor { }
        Mock Get-ChildItem -ModuleName Catzc.Base.Vendor { @() }
        Mock Get-Module -ModuleName Catzc.Base.Vendor { }
    }

    It 'throws when the module is already loaded' {
        Mock Get-Module -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ Name = 'X' } }
        { Install-VendorModule X } | Should -Throw '*fresh PowerShell session*'
    }

    It 'saves from the resolved repository into the vendor root, trusting it' {
        Install-VendorModule X
        Should -Invoke Save-PSResource -ModuleName Catzc.Base.Vendor -ParameterFilter {
            $Name -eq 'X' -and $Repository -eq 'PSGallery' -and $TrustRepository
        }
    }

    It 'passes the required version through as -Version' {
        Install-VendorModule X -RequiredVersion '5.5.0'
        Should -Invoke Save-PSResource -ModuleName Catzc.Base.Vendor -ParameterFilter { $Version -eq '5.5.0' }
    }
}
