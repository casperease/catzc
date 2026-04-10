Describe 'Test-VendorModuleAvailable' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Resolve-VendorRepository -ModuleName Catzc.Base.Vendor { 'PSGallery' }
    }

    It 'returns $true when the source offers the module' {
        Mock Find-PSResource -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ Name = 'X'; Version = '1.0' } }
        Test-VendorModuleAvailable -Name X -Version '1.0' | Should -BeTrue
    }

    It 'returns $false when the source has nothing' {
        Mock Find-PSResource -ModuleName Catzc.Base.Vendor { }
        Test-VendorModuleAvailable -Name X -Version '9.9.9' | Should -BeFalse
    }

    It 'queries the resolved repository with the name and version' {
        Mock Find-PSResource -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ Name = 'X' } }
        Test-VendorModuleAvailable -Name X -Version '2.3' | Out-Null
        Should -Invoke Find-PSResource -ModuleName Catzc.Base.Vendor -ParameterFilter {
            $Name -eq 'X' -and $Version -eq '2.3' -and $Repository -eq 'PSGallery'
        }
    }

    It 'omits the version when none is given' {
        Mock Find-PSResource -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ Name = 'X' } }
        Test-VendorModuleAvailable -Name X | Out-Null
        Should -Invoke Find-PSResource -ModuleName Catzc.Base.Vendor -ParameterFilter { [string]::IsNullOrEmpty($Version) }
    }
}
