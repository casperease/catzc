InModuleScope Catzc.Base.Exporter {
    Describe 'New-CatzcNuGetPackage' -Tag 'L0', 'logic' {
        BeforeAll {
            # A minimal fake built bundle (Source). Built ONCE: tests 'stages', 'writes a manifest',
            # 'carries payload', and 'falls back to default URI' all consume the identical default-fixture
            # package, so they are facets of one pack + one manifest read (ADR-TEST#20) rather than a fresh
            # pack per assertion — packing (Compress-Archive) and Test-ModuleManifest each cost real time,
            # amplified ~5-6x under the sharded/greedy run.
            $script:source = Join-Path $TestDrive ([System.Guid]::NewGuid())
            $moduleDir = Join-Path $source 'automation/Catzc.Base.Widget'
            [System.IO.Directory]::CreateDirectory($moduleDir) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $moduleDir 'Get-Widget.ps1'), 'function Get-Widget { }')
            [System.IO.File]::WriteAllText((Join-Path $moduleDir 'Set-Widget.ps1'), 'function Set-Widget { }')
            [System.IO.File]::WriteAllText((Join-Path $moduleDir 'Catzc.Base.Widget.psd1'), '@{ }')
            [System.IO.File]::WriteAllText((Join-Path $source 'importer.ps1'), '# importer')
            [System.IO.File]::WriteAllText((Join-Path $source 'build.json'), '{}')

            # Fixture export config so the test is hermetic (neutral values, ADR-TEST:3). Blank URIs so the
            # default-fallback assertion reads this same build.
            $fixture = [ordered]@{
                module_guid = '211b36c7-f7eb-4f3c-93f5-9132b535fa56'
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

            $script:pkg = New-CatzcNuGetPackage -Source $source -Version '1.2.3' -DestinationPath (Join-Path $TestDrive ([System.Guid]::NewGuid()))
            $script:manifest = Test-ModuleManifest -Path $script:pkg.Manifest
        }

        It 'stages a packable module (RootModule + manifest) and produces the .nupkg' {
            Test-Path (Join-Path $script:pkg.ModulePath 'Catzc.psm1') | Should -BeTrue
            Test-Path $script:pkg.Manifest | Should -BeTrue
            Test-Path $script:pkg.NuPkg | Should -BeTrue
            [System.IO.Path]::GetFileName($script:pkg.NuPkg) | Should -Be 'Catzc.1.2.3.nupkg'
        }

        It 'writes a manifest with the configured identity and the locked function inventory' {
            $script:manifest.Guid | Should -Be '211b36c7-f7eb-4f3c-93f5-9132b535fa56'
            $script:manifest.Version.ToString() | Should -Be '1.2.3'
            $script:manifest.Author | Should -Be 'Test Author'
            $script:pkg.FunctionCount | Should -Be 2
            $script:manifest.ExportedFunctions.Keys | Should -Contain 'Get-Widget'
            $script:manifest.ExportedFunctions.Keys | Should -Contain 'Set-Widget'
        }

        It 'carries the bundle payload into the package' {
            Test-Path (Join-Path $script:pkg.ModulePath 'automation/Catzc.Base.Widget/Get-Widget.ps1') | Should -BeTrue
            Test-Path (Join-Path $script:pkg.ModulePath 'importer.ps1') | Should -BeTrue
        }

        It 'falls back to a default project and license URI when config leaves them blank' {
            "$($script:manifest.ProjectUri)" | Should -Be 'https://github.com/catzc/catzc'
            "$($script:manifest.LicenseUri)" | Should -Be 'https://github.com/catzc/catzc/blob/main/LICENSE'
        }

        It 'uses the configured project and license URI when set' {
            $custom = [ordered]@{
                module_guid = '211b36c7-f7eb-4f3c-93f5-9132b535fa56'
                package     = [ordered]@{
                    author = 'Test Author'; company = 'Test Co'; description = 'A test package.'
                    tags = @('widget'); project_uri = 'https://forge.example/repo'
                    license_uri = 'https://forge.example/repo/license'
                }
            }
            Mock Get-Config { $custom } -ParameterFilter { $Config -eq 'exporter' }
            # Own build (custom config) into a distinct dest — the shared BeforeAll package uses blank URIs.
            $pkg = New-CatzcNuGetPackage -Source $source -Version '1.2.3' -DestinationPath (Join-Path $TestDrive ([System.Guid]::NewGuid()))
            $m = Test-ModuleManifest -Path $pkg.Manifest
            "$($m.ProjectUri)" | Should -Be 'https://forge.example/repo'
            "$($m.LicenseUri)" | Should -Be 'https://forge.example/repo/license'
        }
    }
}
