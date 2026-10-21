<#
---
catzc:
  immutable:
    with_body_sha: "63343cde14f6"
  edges:
    code: pwsh/Catzc.Base.Vendor/Assert-VendorModuleAvailable.ps1
---
#>

Describe 'Assert-VendorModuleAvailable' -Tag 'L0', 'logic' {
    It 'does not throw when the module is available' {
        Mock Test-VendorModuleAvailable -ModuleName Catzc.Base.Vendor { $true }
        { Assert-VendorModuleAvailable -Name X -Version '1.0' } | Should -Not -Throw
    }

    It 'throws an actionable error when the module is unavailable' {
        Mock Test-VendorModuleAvailable -ModuleName Catzc.Base.Vendor { $false }
        Mock Resolve-VendorRepository -ModuleName Catzc.Base.Vendor { 'PSGallery' }
        { Assert-VendorModuleAvailable -Name X -Version '1.0' } | Should -Throw '*not available*'
    }
}
