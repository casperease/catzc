Describe 'Get-BaseModule' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # Fake repo root with one named and one hidden module folder (TestKit).
        $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Base.Alpha' = @{}; '.vendor' = @{} }

        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ modules = [ordered]@{
                    'Catzc.Base.Alpha' = [ordered]@{ packages = [ordered]@{ demo = @('docs/demo.md', 'x.txt') } }
                }
            }
        }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'returns on-disk modules by default, classified named/hidden with repo-relative paths' {
        $modules = Get-BaseModule
        ($modules | Where-Object Name -EQ 'Catzc.Base.Alpha').Kind | Should -Be 'named'
        ($modules | Where-Object Name -EQ '.vendor').Kind | Should -Be 'hidden'
        ($modules | Where-Object Name -EQ 'Catzc.Base.Alpha').RelativePath | Should -Be 'automation/Catzc.Base.Alpha'
        ($modules | ForEach-Object { $_ -is [Catzc.Base.ModuleSystem.DiskModule] }) | Should -Not -Contain $false
    }

    It 'attaches files.yml packages to their module' {
        $alpha = Get-BaseModule | Where-Object Name -EQ 'Catzc.Base.Alpha'
        $alpha.Packages.Name | Should -Contain 'demo'
        ($alpha.Packages | Where-Object Name -EQ 'demo').Paths | Should -Be @('docs/demo.md', 'x.txt')
        @((Get-BaseModule | Where-Object Name -EQ '.vendor').Packages).Count | Should -Be 0
    }

    It '-Kind filters to the requested kind' {
        (Get-BaseModule -Kind named).Name | Should -Not -Contain '.vendor'
        (Get-BaseModule -Kind hidden).Name | Should -Not -Contain 'Catzc.Base.Alpha'
    }

    It 'maps session modules by provenance: imported / vendored / builtin / residue' {
        Mock Get-Module -ModuleName Catzc.Base.ModuleSystem {
            @(
                [pscustomobject]@{ Name = 'Catzc.Base.Alpha'; ModuleBase = (Join-Path $script:fake.Root 'automation/Catzc.Base.Alpha'); Version = '0.1.0' }
                [pscustomobject]@{ Name = 'Pester'; ModuleBase = (Join-Path $script:fake.Root 'automation/.vendor/Pester'); Version = '5.7.1' }
                [pscustomobject]@{ Name = 'Microsoft.PowerShell.Utility'; ModuleBase = (Join-Path $PSHOME 'Modules/Microsoft.PowerShell.Utility'); Version = '7.0.0' }
                [pscustomobject]@{ Name = 'Foreign'; ModuleBase = (Join-Path ([System.IO.Path]::GetTempPath()) 'elsewhere/Foreign'); Version = '1.0.0' }
            )
        }
        (Get-BaseModule -Kind imported).Name | Should -Be 'Catzc.Base.Alpha'
        (Get-BaseModule -Kind vendored).Name | Should -Be 'Pester'
        (Get-BaseModule -Kind builtin).Name | Should -Be 'Microsoft.PowerShell.Utility'
        $residue = @(Get-BaseModule -Kind residue)
        $residue.Name | Should -Be 'Foreign'
        $residue[0] -is [Catzc.Base.ModuleSystem.SessionModule] | Should -BeTrue
    }
}
