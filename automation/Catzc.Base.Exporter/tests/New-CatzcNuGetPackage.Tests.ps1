InModuleScope Catzc.Base.Exporter {
    Describe 'New-CatzcNuGetPackage' -Tag 'L0', 'logic' {
        BeforeEach {
            # A minimal fake built bundle (Source).
            $script:source = Join-Path $TestDrive ([System.Guid]::NewGuid())
            $moduleDir = Join-Path $source 'automation/Catzc.Base.Widget'
            [System.IO.Directory]::CreateDirectory($moduleDir) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $moduleDir 'Get-Widget.ps1'), 'function Get-Widget { }')
            [System.IO.File]::WriteAllText((Join-Path $moduleDir 'Set-Widget.ps1'), 'function Set-Widget { }')
            [System.IO.File]::WriteAllText((Join-Path $moduleDir 'Catzc.Base.Widget.psd1'), '@{ }')
            [System.IO.File]::WriteAllText((Join-Path $source 'importer.ps1'), '# importer')
            [System.IO.File]::WriteAllText((Join-Path $source 'build.json'), '{}')

            $script:dest = Join-Path $TestDrive ([System.Guid]::NewGuid())

            # Fixture export config so the test is hermetic (neutral values, ADR-TEST:3).
            $fixture = [ordered]@{
                module_guid = 'ca72c000-00d0-1e00-0000-000000000000'
                package     = [ordered]@{
                    author      = 'Test Author'
                    company     = 'Test Co'
                    description = 'A test package.'
                    tags        = @('widget', 'gadget')
                    project_uri = ''
                    license_uri = ''
                }
            }
            Mock Get-Config { $fixture } -ParameterFilter { $Config -eq 'exporter' }
        }

        It 'stages a packable module (RootModule + manifest) and produces the .nupkg' {
            $pkg = New-CatzcNuGetPackage -Source $source -Version '1.2.3' -DestinationPath $dest
            Test-Path (Join-Path $pkg.ModulePath 'Catzc.psm1') | Should -BeTrue
            Test-Path $pkg.Manifest | Should -BeTrue
            Test-Path $pkg.NuPkg | Should -BeTrue
            [System.IO.Path]::GetFileName($pkg.NuPkg) | Should -Be 'Catzc.1.2.3.nupkg'
        }

        It 'writes a manifest with the configured identity and the locked function inventory' {
            $pkg = New-CatzcNuGetPackage -Source $source -Version '1.2.3' -DestinationPath $dest
            $m = Test-ModuleManifest -Path $pkg.Manifest
            $m.Guid | Should -Be 'ca72c000-00d0-1e00-0000-000000000000'
            $m.Version.ToString() | Should -Be '1.2.3'
            $m.Author | Should -Be 'Test Author'
            $pkg.FunctionCount | Should -Be 2
            $m.ExportedFunctions.Keys | Should -Contain 'Get-Widget'
            $m.ExportedFunctions.Keys | Should -Contain 'Set-Widget'
        }

        It 'carries the bundle payload into the package' {
            $pkg = New-CatzcNuGetPackage -Source $source -Version '1.2.3' -DestinationPath $dest
            Test-Path (Join-Path $pkg.ModulePath 'automation/Catzc.Base.Widget/Get-Widget.ps1') | Should -BeTrue
            Test-Path (Join-Path $pkg.ModulePath 'importer.ps1') | Should -BeTrue
        }
    }
}
