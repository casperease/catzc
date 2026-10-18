Describe 'Export-Catzc' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:buildRoot = Join-Path $TestDrive 'out/automation/built/widgets/Catzc/6.6.666'
        Mock Build-Modules { [pscustomobject]@{ BuildRoot = $buildRoot; Version = '6.6.666' } } -ModuleName Catzc.Base.Exporter
        Mock Install-Catzc { [pscustomobject]@{ ModulePath = 'INSTALLED' } } -ModuleName Catzc.Base.Exporter
        Mock New-CatzcNuGetPackage {
            [pscustomobject]@{ NuPkg = (Join-Path $DestinationPath 'Catzc.6.6.666.nupkg'); Version = '6.6.666'; FunctionCount = 3 }
        } -ModuleName Catzc.Base.Exporter
        Mock Get-OutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Base.Exporter
        Mock Write-Message { } -ModuleName Catzc.Base.Exporter
    }

    It 'a disk export builds, then installs that build to the root' {
        Export-Catzc -Root 'C:\work\target' -Force -Silent | Out-Null
        Should -Invoke Build-Modules -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Version -eq 'auto' -and $Silent }
        Should -Invoke Install-Catzc -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $Root -eq 'C:\work\target' -and $Source -eq $buildRoot -and $Force -and $Silent
        }
        Should -Invoke New-CatzcNuGetPackage -ModuleName Catzc.Base.Exporter -Times 0
    }

    It 'a disk export without a root fails before building' {
        { Export-Catzc -Silent } | Should -Throw -ExpectedMessage '*needs -Root*'
        Should -Invoke Build-Modules -ModuleName Catzc.Base.Exporter -Times 0
    }

    It 'passes the build parameters through to Build-Modules' {
        Export-Catzc -Root 'C:\work\target' -Bundle gadgets -Module Catzc.Base.Widget -ModuleProfile gadget-set -VendorPolicy full -Version 1.2.3 -Silent | Out-Null
        Should -Invoke Build-Modules -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $Bundle -eq 'gadgets' -and ($Module -join ',') -eq 'Catzc.Base.Widget' -and $ModuleProfile -eq 'gadget-set' -and $VendorPolicy -eq 'full' -and $Version -eq '1.2.3'
        }
    }

    It 'a nuget export builds, packs the build into out/automation/packages, and needs no root' {
        $package = Export-Catzc -To nuget
        Should -Invoke New-CatzcNuGetPackage -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $Source -eq $buildRoot -and $DestinationPath -eq (Join-Path (Join-Path $TestDrive 'out') 'automation/packages')
        }
        Should -Invoke Install-Catzc -ModuleName Catzc.Base.Exporter -Times 0
        $package.Version | Should -Be '6.6.666'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Message -like 'Packed Catzc 6.6.666 (3 functions)*' }
    }
}
