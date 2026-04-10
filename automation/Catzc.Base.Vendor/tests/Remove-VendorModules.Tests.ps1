Describe 'Remove-VendorModules' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Vendor { }
        Mock Remove-Item -ModuleName Catzc.Base.Vendor { }
        Mock Test-VendorModuleAvailable -ModuleName Catzc.Base.Vendor { $true }
        Mock Get-VendoredModule -ModuleName Catzc.Base.Vendor {
            [pscustomobject]@{ Name = 'Alpha'; Version = '1.0'; Path = 'TestDrive:/Alpha' }
            [pscustomobject]@{ Name = 'Beta'; Version = '2.0'; Path = 'TestDrive:/Beta' }
        }
    }

    It 'is a dry run without -Force: deletes nothing and reports what would go' {
        Remove-VendorModules
        Should -Invoke Remove-Item -ModuleName Catzc.Base.Vendor -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.Vendor -ParameterFilter { $Message -like '*Would remove*' }
    }

    It 'deletes every target with -Force when all are restorable' {
        Remove-VendorModules -Force
        Should -Invoke Remove-Item -ModuleName Catzc.Base.Vendor -Times 2
    }

    It 'scopes the targets with -Name' {
        Remove-VendorModules -Name Alpha -Force
        Should -Invoke Remove-Item -ModuleName Catzc.Base.Vendor -Times 1
    }

    It 'refuses the whole run when any target is not restorable, deleting nothing' {
        Mock Test-VendorModuleAvailable -ModuleName Catzc.Base.Vendor { $Name -ne 'Beta' }
        { Remove-VendorModules -Force } | Should -Throw '*not available*'
        Should -Invoke Remove-Item -ModuleName Catzc.Base.Vendor -Times 0
    }

    It 'no-ops when nothing is vendored' {
        Mock Get-VendoredModule -ModuleName Catzc.Base.Vendor { @() }
        Remove-VendorModules -Force
        Should -Invoke Remove-Item -ModuleName Catzc.Base.Vendor -Times 0
    }
}
