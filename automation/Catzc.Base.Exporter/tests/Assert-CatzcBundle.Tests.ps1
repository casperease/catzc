<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Exporter
    relatives:
      page: docs/references/automation/catzc-base-exporter/tests/Assert-CatzcBundle.Tests.ps1.md
      source: automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

# cspell:ignore nfunction  -- the escape-sequence artifact in the "`nfunction" fixture strings
Describe 'Assert-CatzcBundle' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:newFixtureBuild = {
            $root = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))/Catzc/1.2.3"
            $write = {
                param($relative, $content)
                $target = Join-Path $root $relative
                [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target)) | Out-Null
                [System.IO.File]::WriteAllText($target, $content)
            }
            & $write 'Catzc.psd1' "@{ ModuleVersion = '1.2.3' }"
            & $write 'Catzc.psm1' '. $PSScriptRoot/Import-Catzc.ps1'
            & $write 'Import-Catzc.ps1' '# initializer'
            & $write '.internal/Catzc.Internal.Loader.psm1' '# loader'
            & $write '.internal/assets/types-load.yml' 'cells: {}'
            & $write '.vendor/powershell-yaml/0.4.12/Tests/yaml.Tests.ps1' '# vendored verbatim, allowed'
            & $write 'Catzc.Base.Widget/Catzc.Base.Widget.psd1' "@{ NestedModules = @('Catzc.Base.Widget.functions.ps1'); FunctionsToExport = @('Get-Widget') }"
            & $write 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1' "# source: automation/Catzc.Base.Widget/private/Get-WidgetPart.ps1`nfunction Get-WidgetPart { 'part' }`n# source: automation/Catzc.Base.Widget/Get-Widget.ps1`nfunction Get-Widget { Get-WidgetPart }`n"
            & $write 'Catzc.Base.Widget/configs/widget.yml' 'size: 1'
            & $write 'Catzc.Base.Widget/types/Widget.cs' 'namespace Catzc.Base.Widget; public class Widget { }'
            & $write '.compiled/types/Catzc.Base.Gadget/Gadget.cs' 'namespace Catzc.Base.Gadget; public class Gadget { }'

            $staging = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))"
            [System.IO.Directory]::CreateDirectory("$staging/Catzc.Base.Widget/types") | Out-Null
            [System.IO.Directory]::CreateDirectory("$staging/Catzc.Base.Gadget/types") | Out-Null
            [System.IO.File]::Copy((Join-Path $root 'Catzc.Base.Widget/types/Widget.cs'), "$staging/Catzc.Base.Widget/types/Widget.cs")
            [System.IO.File]::Copy((Join-Path $root '.compiled/types/Catzc.Base.Gadget/Gadget.cs'), "$staging/Catzc.Base.Gadget/types/Gadget.cs")
            Import-InternalModule Types
            $typesHash = (Get-CombinedTypeHash -AutomationRoot $staging).CombinedHash
            & $write ".compiled/Catzc.Types.$typesHash.dll" 'MZ'
            & $write ".compiled/Catzc.Types.$typesHash.json" '{}'

            $build = [ordered]@{
                bundle      = 'widgets'
                version     = '1.2.3'
                typesHash   = $typesHash
                typeSources = @('.compiled/types/Catzc.Base.Gadget/Gadget.cs', 'Catzc.Base.Widget/types/Widget.cs')
                modules     = @('Catzc.Base.Widget')
            }
            $build.contentHash = Get-CatzcContentHash -Path $root
            & $write 'build.json' ($build | ConvertTo-Json)
            [pscustomobject]@{ Root = $root; TypesHash = $typesHash; Build = $build }
        }

        $script:resealBuild = {
            param($fixture)
            $buildFile = Join-Path $fixture.Root 'build.json'
            [System.IO.File]::Delete($buildFile)
            $fixture.Build.contentHash = Get-CatzcContentHash -Path $fixture.Root
            [System.IO.File]::WriteAllText($buildFile, ($fixture.Build | ConvertTo-Json))
        }
    }

    BeforeEach {
        $script:fixture = & $script:newFixtureBuild
    }

    It 'passes a well-formed build (vendored Tests/ allowed)' {
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Not -Throw
    }

    It 'throws on content drift after the build' {
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root 'Catzc.Base.Widget/configs/widget.yml'), 'size: 2')
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*content hash mismatch*'
    }

    It 'throws when <File> is missing' -ForEach @(
        @{ File = 'Catzc.psd1' }
        @{ File = 'Catzc.psm1' }
        @{ File = 'Import-Catzc.ps1' }
        @{ File = '.internal/Catzc.Internal.Loader.psm1' }
        @{ File = '.internal/assets/types-load.yml' }
    ) {
        [System.IO.File]::Delete((Join-Path $fixture.Root $File))
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage "*missing $File*"
    }

    It 'throws when build.json is missing' {
        [System.IO.File]::Delete((Join-Path $fixture.Root 'build.json'))
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*missing build.json*'
    }

    It 'throws when build.json lacks <Field>' -ForEach @(
        @{ Field = 'typesHash' }
        @{ Field = 'bundle' }
    ) {
        $fixture.Build.Remove($Field)
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage "*build.json records no $Field*"
    }

    It 'throws when the folder is not named for the version' {
        $fixture.Build.version = '9.9.9'
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*does not match build.json version 9.9.9*'
    }

    It 'throws when a tests file shipped outside .vendor' {
        [System.IO.Directory]::CreateDirectory((Join-Path $fixture.Root 'Catzc.Base.Widget/Tests')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root 'Catzc.Base.Widget/Tests/Get-Widget.Tests.ps1'), 'x')
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*1 test file(s) shipped*Catzc.Base.Widget/Tests/Get-Widget.Tests.ps1*'
    }

    It 'throws when the types DLL is missing' {
        [System.IO.File]::Delete((Join-Path $fixture.Root ".compiled/Catzc.Types.$($fixture.TypesHash).dll"))
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*exactly one .compiled/Catzc.Types.<hash>.dll, found 0*'
    }

    It 'throws when the types manifest is missing' {
        [System.IO.File]::Delete((Join-Path $fixture.Root ".compiled/Catzc.Types.$($fixture.TypesHash).json"))
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*exactly one .compiled/Catzc.Types.<hash>.json, found 0*'
    }

    It 'throws when the types manifest is not named for the DLL' {
        [System.IO.File]::Move((Join-Path $fixture.Root ".compiled/Catzc.Types.$($fixture.TypesHash).json"), (Join-Path $fixture.Root '.compiled/Catzc.Types.00000000.json'))
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*types manifest .compiled/Catzc.Types.00000000.json is not named for the types DLL*'
    }

    It 'throws when a second types DLL is present' {
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root '.compiled/Catzc.Types.00000000.dll'), 'MZ')
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*exactly one*found 2*'
    }

    It 'throws when the DLL is not named for typesHash' {
        [System.IO.File]::Move((Join-Path $fixture.Root ".compiled/Catzc.Types.$($fixture.TypesHash).dll"), (Join-Path $fixture.Root '.compiled/Catzc.Types.00000000.dll'))
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage "*Catzc.Types.00000000.dll does not match build.json typesHash $($fixture.TypesHash)*"
    }

    It 'throws when a shipped type source differs from what the DLL was built from' {
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root '.compiled/types/Catzc.Base.Gadget/Gadget.cs'), 'namespace Catzc.Base.Gadget; public class Gadget { int x; }')
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*type sources hash to*the DLL was not built from the shipped sources*'
    }

    It 'throws when a recorded type source is missing' {
        [System.IO.File]::Delete((Join-Path $fixture.Root 'Catzc.Base.Widget/types/Widget.cs'))
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*type source Catzc.Base.Widget/types/Widget.cs is recorded in build.json but missing*'
    }

    It 'throws when a shipped type source is not recorded' {
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root '.compiled/types/Catzc.Base.Gadget/Sprocket.cs'), 'namespace Catzc.Base.Gadget; public class Sprocket { }')
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*Sprocket.cs ships but is not in build.json typeSources*'
    }

    It 'throws when a module is missing its <Kind>' -ForEach @(
        @{ Kind = 'manifest'; File = 'Catzc.Base.Widget.psd1' }
        @{ Kind = 'merged'; File = 'Catzc.Base.Widget.functions.ps1' }
    ) {
        [System.IO.File]::Delete((Join-Path $fixture.Root "Catzc.Base.Widget/$File"))
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage "*missing its $Kind Catzc.Base.Widget/$File*"
    }

    It 'throws when a manifest export has no function in the merged file' {
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root 'Catzc.Base.Widget/Catzc.Base.Widget.psd1'), "@{ NestedModules = @('Catzc.Base.Widget.functions.ps1'); FunctionsToExport = @('Get-Widget', 'Set-Widget') }")
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*does not define: Set-Widget*'
    }

    It 'throws when the manifest nests a file named for the module (a second same-named module)' {
        [System.IO.File]::Move((Join-Path $fixture.Root 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1'), (Join-Path $fixture.Root 'Catzc.Base.Widget/Catzc.Base.Widget.ps1'))
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root 'Catzc.Base.Widget/Catzc.Base.Widget.psd1'), "@{ NestedModules = @('Catzc.Base.Widget.ps1'); FunctionsToExport = @('Get-Widget') }")
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*missing its merged Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1*'
    }

    It 'throws when the manifest does not nest exactly the merged file' {
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root 'Catzc.Base.Widget/Catzc.Base.Widget.psd1'), "@{ NestedModules = @('Catzc.Base.Widget.ps1'); FunctionsToExport = @('Get-Widget') }")
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage "*NestedModules must be exactly 'Catzc.Base.Widget.functions.ps1', found 'Catzc.Base.Widget.ps1'*"
    }

    It 'does not count a nested function as a top-level export' {
        [System.IO.File]::WriteAllText((Join-Path $fixture.Root 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1'), "function Get-WidgetPart { function Get-Widget { } }`n")
        & $script:resealBuild $fixture
        { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -ExpectedMessage '*does not define: Get-Widget*'
    }

    It 'throws when module folders and build.json modules disagree' {
        [System.IO.Directory]::CreateDirectory((Join-Path $fixture.Root 'Catzc.Base.Gadget')) | Out-Null
        $fixture.Build.modules = @('Catzc.Base.Widget', 'Catzc.Base.Sprocket')
        & $script:resealBuild $fixture
        $thrown = { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike "*module 'Catzc.Base.Sprocket' is recorded in build.json but has no folder*"
        $thrown.Exception.Message | Should -BeLike "*module folder 'Catzc.Base.Gadget' is not recorded in build.json*"
    }

    It 'collects every violation into one throw' {
        [System.IO.File]::Delete((Join-Path $fixture.Root 'Catzc.psm1'))
        [System.IO.File]::Delete((Join-Path $fixture.Root 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1'))
        $thrown = { Assert-CatzcBundle -Path $fixture.Root } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike '*missing Catzc.psm1*'
        $thrown.Exception.Message | Should -BeLike '*missing its merged*'
        $thrown.Exception.Message | Should -BeLike '*content hash mismatch*'
    }
}
