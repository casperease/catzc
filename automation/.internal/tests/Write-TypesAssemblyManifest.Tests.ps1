<#
---
catzc:
  derived:
    path: automation/.internal/tests/Write-TypesAssemblyManifest.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Internal.Tests
---
#>

Describe 'Write-TypesAssemblyManifest' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:dll = Join-Path $TestDrive 'Catzc.Types.abcd1234.dll'
        Add-Type -TypeDefinition 'namespace Fx { public class Widget { } public class Gadget { } }' -OutputAssembly $script:dll -OutputType Library
    }

    It 'writes the hash-named json beside the assembly and returns its path' {
        $path = Write-TypesAssemblyManifest -Path $dll
        $path | Should -Be (Join-Path $TestDrive 'Catzc.Types.abcd1234.json')
        [System.IO.File]::Exists($path) | Should -BeTrue
    }

    It 'records the hash from the file name and every type with aliases and display' {
        $manifest = [System.IO.File]::ReadAllText((Write-TypesAssemblyManifest -Path $dll)) | ConvertFrom-Json
        $manifest.hash | Should -Be 'abcd1234'
        @($manifest.types.name) | Should -Be @('Fx.Gadget', 'Fx.Widget')
        @($manifest.types[0].aliases).Count | Should -Be 0
        @($manifest.types[0].display).Count | Should -Be 0
    }

    It 'writes LF line endings, no byte-order mark, and a final newline' {
        $bytes = [System.IO.File]::ReadAllBytes((Write-TypesAssemblyManifest -Path $dll))
        $bytes[0] | Should -Not -Be 0xEF
        $bytes -contains 13 | Should -BeFalse
        $bytes[-1] | Should -Be 10
    }

    It 'leaves an existing manifest untouched' {
        $path = Write-TypesAssemblyManifest -Path $dll
        [System.IO.File]::WriteAllText($path, 'kept')
        Write-TypesAssemblyManifest -Path $dll | Out-Null
        [System.IO.File]::ReadAllText($path) | Should -Be 'kept'
    }

    It 'leaves no temporary file behind' {
        Write-TypesAssemblyManifest -Path $dll | Out-Null
        @([System.IO.Directory]::EnumerateFiles($TestDrive, '*.tmp')).Count | Should -Be 0
    }

    It 'throws when the assembly does not exist' {
        { Write-TypesAssemblyManifest -Path (Join-Path $TestDrive 'Catzc.Types.0000.dll') } | Should -Throw '*does not exist*'
    }
}
