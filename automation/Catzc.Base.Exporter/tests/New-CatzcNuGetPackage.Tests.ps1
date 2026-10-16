<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Exporter
    relatives:
      page: docs/references/automation/catzc-base-exporter/tests/New-CatzcNuGetPackage.Tests.ps1.md
      source: automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
    adrs:
      - ADR-AUTO-TEST#{3,20}
---
#>

# cspell:ignore nfunction  -- the escape-sequence artifact in the "`nfunction" fixture strings
InModuleScope Catzc.Base.Exporter {
    Describe 'New-CatzcNuGetPackage' -Tag 'L0', 'logic' {
        BeforeAll {
            $script:source = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))/Catzc/1.2.3"
            $write = {
                param($relative, $content)
                $target = Join-Path $script:source $relative
                [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target)) | Out-Null
                [System.IO.File]::WriteAllText($target, $content)
            }
            & $write 'Catzc.psm1' '. (Join-Path $PSScriptRoot ''Import-Catzc.ps1'')'
            & $write 'Import-Catzc.ps1' '# initializer'
            & $write 'build.json' '{}'
            & $write '.internal/Catzc.Internal.Loader.psm1' '# loader'
            & $write '.compiled/Catzc.Types.abc12345.dll' 'MZ'
            & $write '.vendor/powershell-yaml/0.4.12/README.md' 'vendored'
            & $write 'Catzc.Base.Widget/Catzc.Base.Widget.psd1' "@{ FunctionsToExport = @('Get-Widget', 'Set-Widget') }"
            & $write 'Catzc.Base.Widget/Catzc.Base.Widget.ps1' "function Get-Widget { }`nfunction Set-Widget { }`n"
            & $write 'Catzc.Base.Gadget/Catzc.Base.Gadget.psd1' "@{ FunctionsToExport = @('Get-Gadget') }"
            & $write 'Catzc.Base.Gadget/Catzc.Base.Gadget.ps1' "function Get-Gadget { }`n"
            New-ModuleManifest -Path (Join-Path $script:source 'Catzc.psd1') -RootModule 'Catzc.psm1' -ModuleVersion '1.2.3' `
                -Guid '211b36c7-f7eb-4f3c-93f5-9132b535fa56' -Author 'Test Author' -CompanyName 'Test Co' -Description 'A test package.' `
                -PowerShellVersion '7.4' -FunctionsToExport @() -CmdletsToExport @() -VariablesToExport @() -AliasesToExport @() -Tags 'widget', 'gadget'

            $script:destination = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))"
            $script:pkg = New-CatzcNuGetPackage -Source $script:source -DestinationPath $script:destination

            Add-Type -AssemblyName System.IO.Compression.FileSystem
            $zip = [System.IO.Compression.ZipFile]::OpenRead($script:pkg.NuPkg)
            try {
                $script:entries = @($zip.Entries | ForEach-Object { [System.Uri]::UnescapeDataString($_.FullName.Replace('\', '/')) })
            }
            finally {
                $zip.Dispose()
            }
        }

        It 'packs the build folder into a version-named Catzc .nupkg at the destination' {
            Test-Path $script:pkg.NuPkg | Should -BeTrue
            [System.IO.Path]::GetFileName($script:pkg.NuPkg) | Should -Be 'Catzc.1.2.3.nupkg'
            $script:pkg.Version | Should -Be '1.2.3'
            $script:pkg.Manifest | Should -Be (Join-Path $script:source 'Catzc.psd1')
            $script:pkg.ModulePath | Should -Be $script:source
        }

        It 'counts the public functions the inner modules export' {
            $script:pkg.FunctionCount | Should -Be 3
        }

        It 'carries the whole build, dot folders included (loader, types DLL, vendored dependencies)' {
            $script:entries | Should -Contain 'Catzc.psd1'
            $script:entries | Should -Contain 'Catzc.psm1'
            $script:entries | Should -Contain 'Import-Catzc.ps1'
            $script:entries | Should -Contain 'Catzc.Base.Widget/Catzc.Base.Widget.ps1'
            $script:entries | Should -Contain '.internal/Catzc.Internal.Loader.psm1'
            $script:entries | Should -Contain '.compiled/Catzc.Types.abc12345.dll'
            $script:entries | Should -Contain '.vendor/powershell-yaml/0.4.12/README.md'
        }

        It 'refuses a folder that is not a build (no Catzc.psd1)' {
            $empty = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))"
            [System.IO.Directory]::CreateDirectory($empty) | Out-Null
            { New-CatzcNuGetPackage -Source $empty -DestinationPath $script:destination } | Should -Throw
        }
    }
}
