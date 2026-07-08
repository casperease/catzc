Describe 'Copy-CatzcLiveTree' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixtureRoot = Join-Path $TestDrive 'repo'

        # Neutral fixture identities (ADR-TEST:3) — never a real module name.
        $script:members = @(
            'automation/Catzc.Base.Widget/Get-Widget.ps1'
            'automation/Catzc.Base.Widget/private/Resolve-Widget.ps1'
            'automation/Catzc.Base.Widget/configs/widget.yml'
            'automation/Catzc.Base.Widget/assets/seed.txt'
            'automation/Catzc.Base.Widget/tests/Get-Widget.Tests.ps1'
            'automation/Catzc.Base.Gadget/Get-Gadget.ps1'
            'automation/.internal/Catzc.Internal.Loader.psm1'
            'automation/.internal/tests/Import-AllModules.Tests.ps1'
            'automation/.vendor/powershell-yaml/0.4.7/powershell-yaml.psm1'
            'automation/.vendor/Pester/5.7.1/Pester.psm1'
        )

        # Materialise the fixture repo: one committed types DLL plus a source file per member.
        $compiled = Join-Path $fixtureRoot 'automation/.compiled'
        [System.IO.Directory]::CreateDirectory($compiled) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $compiled 'Catzc.Types.abc12345.dll'), 'MZ')
        foreach ($member in $script:members) {
            $path = Join-Path $fixtureRoot $member
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
            [System.IO.File]::WriteAllText($path, 'x')
        }

        Mock Get-RepositoryRoot { $fixtureRoot } -ModuleName Catzc.Base.Exporter
        Mock Get-GlobSetFile { $script:members } -ModuleName Catzc.Base.Exporter
    }

    It 'carries the module runtime surface — ps1, private, configs, assets' {
        $result = InModuleScope Catzc.Base.Exporter -Parameters @{ dest = (Join-Path $TestDrive 'o1') } {
            param($dest)
            Copy-CatzcLiveTree -Destination $dest -Module 'Catzc.Base.Widget' -DryRun
        }
        $result | Should -Contain 'automation/Catzc.Base.Widget/Get-Widget.ps1'
        $result | Should -Contain 'automation/Catzc.Base.Widget/private/Resolve-Widget.ps1'
        $result | Should -Contain 'automation/Catzc.Base.Widget/configs/widget.yml'
        $result | Should -Contain 'automation/Catzc.Base.Widget/assets/seed.txt'
    }

    It 'never carries the tests/ verification surface (default-deny)' {
        $result = InModuleScope Catzc.Base.Exporter -Parameters @{ dest = (Join-Path $TestDrive 'o2') } {
            param($dest)
            Copy-CatzcLiveTree -Destination $dest -Module 'Catzc.Base.Widget' -DryRun
        }
        @($result | Where-Object { $_ -like '*/tests/*' }) | Should -BeNullOrEmpty
    }

    It 'always carries .internal and the single committed types DLL' {
        $result = InModuleScope Catzc.Base.Exporter -Parameters @{ dest = (Join-Path $TestDrive 'o3') } {
            param($dest)
            Copy-CatzcLiveTree -Destination $dest -Module 'Catzc.Base.Widget' -DryRun
        }
        $result | Should -Contain 'automation/.internal/Catzc.Internal.Loader.psm1'
        $result | Should -Contain 'automation/.compiled/Catzc.Types.abc12345.dll'
    }

    It 'only excludes an unselected module' {
        $result = InModuleScope Catzc.Base.Exporter -Parameters @{ dest = (Join-Path $TestDrive 'o4') } {
            param($dest)
            Copy-CatzcLiveTree -Destination $dest -Module 'Catzc.Base.Widget' -DryRun
        }
        @($result | Where-Object { $_ -like 'automation/Catzc.Base.Gadget/*' }) | Should -BeNullOrEmpty
    }

    It 'runtime vendor policy carries only powershell-yaml' {
        $result = InModuleScope Catzc.Base.Exporter -Parameters @{ dest = (Join-Path $TestDrive 'o5') } {
            param($dest)
            Copy-CatzcLiveTree -Destination $dest -Module 'Catzc.Base.Widget' -VendorPolicy runtime -DryRun
        }
        ($result -like 'automation/.vendor/powershell-yaml/*') | Should -Not -BeNullOrEmpty
        @($result | Where-Object { $_ -like 'automation/.vendor/Pester/*' }) | Should -BeNullOrEmpty
    }

    It 'full vendor policy carries Pester too' {
        $result = InModuleScope Catzc.Base.Exporter -Parameters @{ dest = (Join-Path $TestDrive 'o6') } {
            param($dest)
            Copy-CatzcLiveTree -Destination $dest -Module 'Catzc.Base.Widget' -VendorPolicy full -DryRun
        }
        ($result -like 'automation/.vendor/Pester/*') | Should -Not -BeNullOrEmpty
    }

    It 'actually copies the payload and omits tests on disk' {
        $dest = Join-Path $TestDrive 'bundle'
        InModuleScope Catzc.Base.Exporter -Parameters @{ dest = $dest } {
            param($dest)
            Copy-CatzcLiveTree -Destination $dest -Module 'Catzc.Base.Widget' | Out-Null
        }
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Widget/Get-Widget.ps1') | Should -BeTrue
        Test-Path (Join-Path $dest 'automation/.compiled/Catzc.Types.abc12345.dll') | Should -BeTrue
        Test-Path (Join-Path $dest 'automation/Catzc.Base.Widget/tests/Get-Widget.Tests.ps1') | Should -BeFalse
    }

    It 'throws when the .compiled build is ambiguous (not exactly one DLL)' {
        $secondDll = Join-Path $fixtureRoot 'automation/.compiled/Catzc.Types.def67890.dll'
        [System.IO.File]::WriteAllText($secondDll, 'MZ')
        try {
            {
                InModuleScope Catzc.Base.Exporter -Parameters @{ dest = (Join-Path $TestDrive 'o7') } {
                    param($dest)
                    Copy-CatzcLiveTree -Destination $dest -Module 'Catzc.Base.Widget' -DryRun
                }
            } | Should -Throw -ExpectedMessage '*exactly one*'
        }
        finally {
            [System.IO.File]::Delete($secondDll)
        }
    }
}
