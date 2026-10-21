<#
---
catzc:
  immutable:
    with_body_sha: "28dca9c8fef4"
  edges:
    docs: "[Get-LoadedTypeDrift.Tests.ps1.md](docs/references/pwsh/internal/tests/Get-LoadedTypeDrift.Tests.ps1.md)"
    cites:
      - ADR-BCL-TYPES-STALETYPESGUARD
      - ADR-BCL-TYPES-ONEDRIFTMEASURE
---
#>

BeforeAll {
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Types.psm1') -Force
}

Describe 'Get-LoadedTypeDrift' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-ONEDRIFTMEASURE' {
    BeforeAll {
        function New-FixtureRoot {
            param([string[]] $Source)
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            foreach ($key in $Source) {
                $module, $base = $key -split '/', 2
                $path = Join-Path $root "$module/types/$base.cs"
                [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
                [System.IO.File]::WriteAllText($path, "namespace $module;`npublic sealed class $base { }`n")
            }
            $root
        }
        function Set-Record {
            param([string] $Root, [string] $Hash, [System.Collections.IDictionary] $Snapshot)
            $records = Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly -ErrorAction Ignore
            if (-not $records) {
                Set-Variable -Name '__CatzcTypes' -Scope Global -Value @{}
                $records = Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly
            }
            $records[[System.IO.Path]::GetFullPath($Root)] = [pscustomobject]@{ Hash = $Hash; Snapshot = $Snapshot }
        }
        $script:roots = [System.Collections.Generic.List[string]]::new()
    }

    AfterEach {
        $records = Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly -ErrorAction Ignore
        foreach ($root in $script:roots) {
            if ($records) {
                $records.Remove([System.IO.Path]::GetFullPath($root))
            }
        }
        $script:roots.Clear()
    }

    It 'is current when no type of the root is loaded in this process' {
        $root = New-FixtureRoot 'Catzc.Widget/Gadget'
        $state = Get-LoadedTypeDrift -ModulesRoot $root
        $state.Loaded | Should -BeFalse
        $state.Current | Should -BeTrue
        $state.Summary | Should -BeNullOrEmpty
    }

    It 'is current when the root''s record matches its sources' {
        $root = New-FixtureRoot 'Catzc.Base.Objects/ConsoleText'
        $script:roots.Add($root)
        $hash = Get-CombinedTypeHash $root
        Set-Record -Root $root -Hash $hash.CombinedHash -Snapshot $hash.Snapshot
        $state = Get-LoadedTypeDrift -ModulesRoot $root
        $state.Loaded | Should -BeTrue
        $state.Current | Should -BeTrue
        @($state.Drift) | Should -HaveCount 0
    }

    It 'names every source added, changed, or removed since the root''s load, with both hashes' {
        $root = New-FixtureRoot 'Catzc.Base.Objects/ConsoleText', 'Catzc.Widget/Gadget'
        $script:roots.Add($root)
        Set-Record -Root $root -Hash 'aaaa1111' -Snapshot ([ordered]@{ 'Catzc.Base.Objects/ConsoleText' = 'OLD'; 'Catzc.Widget/Sprocket' = 'GONE' })
        $state = Get-LoadedTypeDrift -ModulesRoot $root
        $state.Current | Should -BeFalse
        $state.LoadedHash | Should -Be 'aaaa1111'
        $state.SourceHash | Should -Be (Get-CombinedTypeHash $root).CombinedHash
        @($state.Drift) | Should -Be @('changed Catzc.Base.Objects/ConsoleText', 'added Catzc.Widget/Gadget', 'removed Catzc.Widget/Sprocket')
        @($state.MissingTypes) | Should -Be @('added Catzc.Widget/Gadget')
        $state.Summary | Should -BeLike "*changed since they were loaded (aaaa1111 -> $($state.SourceHash))*"
    }

    It 'compares a root with no record against the root that loaded the types, and names a type the process lacks' {
        $other = New-FixtureRoot 'Catzc.Base.Objects/ConsoleText'
        $root = New-FixtureRoot 'Catzc.Base.Objects/ConsoleText', 'Catzc.Widget/Gadget'
        $script:roots.Add($other)
        Set-Record -Root $other -Hash 'bbbb2222' -Snapshot ([ordered]@{ 'Catzc.Base.Objects/ConsoleText' = 'OTHER' })
        $state = Get-LoadedTypeDrift -ModulesRoot $root
        $state.Current | Should -BeFalse
        @($state.Drift) | Should -Contain 'changed Catzc.Base.Objects/ConsoleText'
        @($state.Drift) | Should -Contain 'not loaded Catzc.Widget/Gadget'
        @($state.MissingTypes) | Should -Be @('not loaded Catzc.Widget/Gadget')
        $state.Summary | Should -BeLike '*already loaded from*differ from the sources under*'
    }
}
