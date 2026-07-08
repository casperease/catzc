Describe 'Build-Catzc' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:out = Join-Path $TestDrive ([System.Guid]::NewGuid())

        Mock Get-Config {
            [ordered]@{ default_profile = 'full'; vendor_policy = 'runtime'; direct_install_version = '6.6.666'; version = '0.1.0' }
        } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Config -eq 'exporter' }
        Mock Get-OutputRoot { $out } -ModuleName Catzc.Base.Exporter
        Mock Get-ModuleProfile { @('Catzc.Base.Widget', 'Catzc.Base.Gadget') } -ModuleName Catzc.Base.Exporter
        Mock Get-GitCurrentCommit { 'deadbeef' } -ModuleName Catzc.Base.Exporter
        # Fake payload: materialise the one thing Assert requires (the DLL); Build adds importer.ps1 + build.json.
        Mock Copy-CatzcLiveTree {
            param($Destination)
            $compiled = Join-Path $Destination 'automation/.compiled'
            [System.IO.Directory]::CreateDirectory($compiled) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $compiled 'Catzc.Types.abc12345.dll'), 'MZ')
            @('automation/.compiled/Catzc.Types.abc12345.dll')
        } -ModuleName Catzc.Base.Exporter
    }

    It 'writes build.json with the content hash and provenance' {
        $result = Build-Catzc -Silent
        $buildFile = Join-Path $result.Path 'build.json'
        Test-Path $buildFile | Should -BeTrue
        $build = Get-Content $buildFile -Raw | ConvertFrom-Json
        $build.version | Should -Be '6.6.666'
        $build.profile | Should -Be 'full'
        $build.contentHash | Should -Be $result.ContentHash
        $build.sourceCommit | Should -Be 'deadbeef'
    }

    It 'writes the bundle importer.ps1 at the bundle root' {
        $result = Build-Catzc -Silent
        Test-Path (Join-Path $result.Path 'importer.ps1') | Should -BeTrue
    }

    It 'lands at the version folder under out/catzc' {
        $result = Build-Catzc -Silent
        $result.Path | Should -Be (Join-Path $out 'catzc/6.6.666')
    }

    It 'passes its own Assert-CatzcBundle self-check' {
        { Build-Catzc -Silent } | Should -Not -Throw
    }

    It 'overrides the profile and version from parameters' {
        Build-Catzc -Silent -ModuleProfile azure -Version 1.2.3 | Out-Null
        Should -Invoke Get-ModuleProfile -ModuleName Catzc.Base.Exporter -ParameterFilter { $Name -eq 'azure' }
        Test-Path (Join-Path $out 'catzc/1.2.3/build.json') | Should -BeTrue
    }
}
