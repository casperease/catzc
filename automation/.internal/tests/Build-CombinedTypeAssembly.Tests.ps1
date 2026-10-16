<#
---
catzc:
  derived:
    path: automation/.internal/tests/Build-CombinedTypeAssembly.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    relatives:
      page: docs/references/automation/internal/tests/Build-CombinedTypeAssembly.Tests.ps1.md
---
#>

# cspell:ignore npublic  -- the escape-sequence artifact in the "namespace X;`npublic class" fixture strings
Describe 'Get-CombinedTypeHash module selection' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture automation root: two modules with one type each, plus a module with no types/ folder.
        $script:root = Join-Path $TestDrive 'automation'
        foreach ($entry in @(@('Widget', 'Sprocket'), @('Gadget', 'Lever'))) {
            $typesDirectory = Join-Path $root "$($entry[0])/types"
            [System.IO.Directory]::CreateDirectory($typesDirectory) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $typesDirectory "$($entry[1]).cs"), "namespace $($entry[0]);`npublic class $($entry[1]) { }")
        }
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'Gizmo')) | Out-Null
    }

    It 'hashes every module when -Module is omitted' {
        @((Get-CombinedTypeHash $root).Files.Key) | Should -Be @('Gadget/Lever', 'Widget/Sprocket')
    }

    It 'hashes only the selected modules, and keys a different hash than the full set' {
        $subset = Get-CombinedTypeHash $root -Module 'Widget'
        @($subset.Files.Key) | Should -Be @('Widget/Sprocket')
        $subset.CombinedHash | Should -Not -Be (Get-CombinedTypeHash $root).CombinedHash
    }

    It 'a selected module without types/ contributes nothing' {
        @((Get-CombinedTypeHash $root -Module 'Widget', 'Gizmo').Files.Key) | Should -Be @('Widget/Sprocket')
    }

    It 'an empty selection hashes nothing (never widens to every module)' {
        $result = Get-CombinedTypeHash $root -Module @()
        $result.CombinedHash | Should -BeNullOrEmpty
        @($result.Files).Count | Should -Be 0
    }
}

Describe 'Build-CombinedTypeAssembly' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:runId = 'r' + [guid]::NewGuid().ToString('N').Substring(0, 8)
        $script:widget = "CatzcBuildWidget$runId"
        $script:gadget = "CatzcBuildGadget$runId"
        $script:root = Join-Path $TestDrive 'automation'
        foreach ($entry in @(@($widget, 'Sprocket'), @($gadget, 'Lever'))) {
            $typesDirectory = Join-Path $root "$($entry[0])/types"
            [System.IO.Directory]::CreateDirectory($typesDirectory) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $typesDirectory "$($entry[1]).cs"), "namespace $($entry[0]);`npublic class $($entry[1]) { }")
        }
        $script:output = Join-Path $TestDrive 'build/.compiled'
        $script:built = Build-CombinedTypeAssembly -AutomationRoot $root -OutputDirectory $output
    }

    It 'writes the Catzc.Types DLL named by the combined hash of the compiled sources' {
        $expected = (Get-CombinedTypeHash $root).CombinedHash
        $built.Hash | Should -Be $expected
        $built.Path | Should -Be (Join-Path $output "Catzc.Types.$expected.dll")
        [System.IO.File]::Exists($built.Path) | Should -BeTrue
        $built.Compiled | Should -BeTrue
        @($built.Files.Key) | Should -Be @("$gadget/Lever", "$widget/Sprocket")
    }

    It 'does not load the assembly it writes' {
        ([System.Management.Automation.PSTypeName]"$widget.Sprocket").Type | Should -BeNullOrEmpty
    }

    It 'leaves no temp file behind' {
        @([System.IO.Directory]::EnumerateFiles($output, '*.tmp')).Count | Should -Be 0
    }

    It 'keeps an existing DLL of the same hash without recompiling' {
        $again = Build-CombinedTypeAssembly -AutomationRoot $root -OutputDirectory $output
        $again.Compiled | Should -BeFalse
        $again.Path | Should -Be $built.Path
    }

    It 'writes the hash-named manifest beside the DLL, listing its types' {
        $built.Manifest | Should -Be (Join-Path $output "Catzc.Types.$($built.Hash).json")
        $manifest = [System.IO.File]::ReadAllText($built.Manifest) | ConvertFrom-Json
        $manifest.hash | Should -Be $built.Hash
        @($manifest.types.name) | Should -Be @("$gadget.Lever", "$widget.Sprocket")
    }

    It 'restores a missing manifest when the DLL of the same hash already exists' {
        [System.IO.File]::Delete($built.Manifest)
        $again = Build-CombinedTypeAssembly -AutomationRoot $root -OutputDirectory $output
        $again.Compiled | Should -BeFalse
        [System.IO.File]::Exists($again.Manifest) | Should -BeTrue
    }

    It 'compiles only the selected modules, under the subset hash' {
        $subsetOutput = Join-Path $TestDrive 'subset'
        $subset = Build-CombinedTypeAssembly -AutomationRoot $root -Module $widget -OutputDirectory $subsetOutput
        $subset.Hash | Should -Be (Get-CombinedTypeHash $root -Module $widget).CombinedHash
        $subset.Hash | Should -Not -Be $built.Hash
        @([System.IO.Directory]::EnumerateFiles($subsetOutput, 'Catzc.Types.*.dll')).Count | Should -Be 1
    }

    It 'throws the compiler error and leaves no temp file behind when the sources do not compile' {
        $brokenRoot = Join-Path $TestDrive 'broken'
        $brokenTypes = Join-Path $brokenRoot "$widget/types"
        [System.IO.Directory]::CreateDirectory($brokenTypes) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $brokenTypes 'Sprocket.cs'), "namespace $widget;`npublic class Sprocket { int X => Missing(); }")
        $brokenOutput = Join-Path $TestDrive 'broken-output'
        { Build-CombinedTypeAssembly -AutomationRoot $brokenRoot -OutputDirectory $brokenOutput } | Should -Throw
        @([System.IO.Directory]::EnumerateFiles($brokenOutput)).Count | Should -Be 0
    }

    It 'names the source in the repository, not its frozen copy, in a compiler error' {
        $namedRoot = Join-Path $TestDrive 'named'
        $namedTypes = Join-Path $namedRoot "$widget/types"
        [System.IO.Directory]::CreateDirectory($namedTypes) | Out-Null
        $namedSource = Join-Path $namedTypes 'Sprocket.cs'
        [System.IO.File]::WriteAllText($namedSource, "namespace $widget;`npublic class Sprocket { int X => Missing(); }")
        $message = try {
            Build-CombinedTypeAssembly -AutomationRoot $namedRoot -OutputDirectory (Join-Path $TestDrive 'named-output')
            ''
        }
        catch {
            $_.Exception.Message
        }
        $message.Contains($namedSource) | Should -BeTrue -Because "the error should name $namedSource, not a temp copy: $message"
        $message | Should -Not -BeLike '*catzc-types-*'
    }

    It 'compiles the sources as they were hashed when a source is saved while the compiler runs' {
        $raceRoot = Join-Path $TestDrive 'race'
        $raceTypes = Join-Path $raceRoot "$widget/types"
        [System.IO.Directory]::CreateDirectory($raceTypes) | Out-Null
        $raceSource = Join-Path $raceTypes 'Sprocket.cs'
        [System.IO.File]::WriteAllText($raceSource, "namespace $widget;`npublic class Sprocket { public int Teeth => 12; }")
        $hashedBefore = (Get-CombinedTypeHash $raceRoot).CombinedHash
        Mock Add-Type -ModuleName Catzc.Internal.Types {
            [System.IO.File]::WriteAllText($raceSource, "namespace $widget;`npublic class Sprocket { int X => Missing(); }")
            Microsoft.PowerShell.Utility\Add-Type @PesterBoundParameters
        }

        $raced = Build-CombinedTypeAssembly -AutomationRoot $raceRoot -OutputDirectory (Join-Path $TestDrive 'race-output')

        Should -Invoke Add-Type -ModuleName Catzc.Internal.Types -Times 1 -Exactly -Because 'the save must land while the compiler runs'
        $raced.Hash | Should -Be $hashedBefore
        [System.IO.Path]::GetFileName($raced.Path) | Should -Be "Catzc.Types.$hashedBefore.dll"
        [System.IO.File]::Exists($raced.Path) | Should -BeTrue
        @([System.IO.Directory]::EnumerateDirectories([System.IO.Path]::GetTempPath(), "catzc-types-$PID-*")).Count | Should -Be 0 -Because 'the frozen copy is removed'
    }

    It 'returns nothing and writes nothing when the selection ships no C# source' {
        $emptyOutput = Join-Path $TestDrive 'empty'
        Build-CombinedTypeAssembly -AutomationRoot $root -Module 'Gizmo' -OutputDirectory $emptyOutput | Should -BeNullOrEmpty
        [System.IO.Directory]::Exists($emptyOutput) | Should -BeFalse
    }
}
