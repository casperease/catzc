<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Vendor/tests/Remove-VendorModules.Tests.ps1
    folder: tests
    name: remove-vendor-modules-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Vendor
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Remove-VendorModules' -Tag 'L0', 'logic' {
    BeforeEach {
        # The run-mode guard is its own boundary (covered in the build-mode block below).
        Mock Assert-SourceTree -ModuleName Catzc.Base.Vendor { }
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

Describe 'Remove-VendorModules — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package, before deleting' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        Mock Remove-Item -ModuleName Catzc.Base.Vendor { }
        { Remove-VendorModules -Force } | Should -Throw '*Remove-VendorModules operates on the catzc source tree*'
        Should -Invoke Remove-Item -ModuleName Catzc.Base.Vendor -Times 0
    }
}
