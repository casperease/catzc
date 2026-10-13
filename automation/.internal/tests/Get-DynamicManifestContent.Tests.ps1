Describe 'Get-DynamicManifestContent' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'produces byte-identical output for identical inputs (deterministic)' {
        $first = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('private/B.ps1', 'A.ps1') -FunctionToExport @('A') }
        $second = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('private/B.ps1', 'A.ps1') -FunctionToExport @('A') }
        $first | Should -BeExactly $second
    }

    It 'emits forward-slash paths and a single trailing newline' {
        $text = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('private/Get-Foo.ps1') -FunctionToExport @('Get-Foo') }
        $text | Should -Match 'private/Get-Foo\.ps1'
        $text | Should -Not -Match '\\'
        $text.EndsWith("`n") | Should -BeTrue
        $text.EndsWith("`n`n") | Should -BeFalse
    }

    It 'renders empty collections as @()' {
        $text = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('A.ps1') -FunctionToExport @('A') }
        $text | Should -Match 'CmdletsToExport   = @\(\)'
        $text | Should -Match 'VariablesToExport = @\(\)'
    }

    It 'exports every function as a wildcard under -ExportAll' {
        $text = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('A.ps1') -ExportAll }
        $text | Should -Match "FunctionsToExport = @\('\*'\)"
    }
}

Describe 'New-DynamicManifest' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force

        # A fixture module folder on disk: two public files and one private file.
        function New-WidgetModule {
            param([string] $Name)
            $path = Join-Path $TestDrive $Name
            [System.IO.Directory]::CreateDirectory((Join-Path $path 'private')) | Out-Null
            foreach ($file in 'Get-WidgetB.ps1', 'Get-WidgetA.ps1', 'private/Get-WidgetPart.ps1') {
                [System.IO.File]::WriteAllText((Join-Path $path $file), '')
            }
            $path
        }
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'derives the lists from the folder by default (private first, each group ordinal-sorted)' {
        $path = New-WidgetModule 'DerivedWidget'
        $manifest = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } { param($P) New-DynamicManifest -ModulePath $P }
        $expected = InModuleScope Catzc.Internal.Bootstrap {
            Get-DynamicManifestContent -NestedModule @('private/Get-WidgetPart.ps1', 'Get-WidgetA.ps1', 'Get-WidgetB.ps1') -FunctionToExport @('Get-WidgetA', 'Get-WidgetB')
        }
        $manifest | Should -Be (Join-Path $path 'DerivedWidget.psd1')
        [System.IO.File]::ReadAllText($manifest) | Should -BeExactly $expected
    }

    It 'emits the explicit lists verbatim and does not enumerate the folder' {
        $path = New-WidgetModule 'MergedWidget'
        $manifest = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } {
            param($P) New-DynamicManifest -ModulePath $P -NestedModule 'MergedWidget.ps1' -FunctionToExport 'Get-WidgetA', 'Get-WidgetB'
        }
        $expected = InModuleScope Catzc.Internal.Bootstrap {
            Get-DynamicManifestContent -NestedModule @('MergedWidget.ps1') -FunctionToExport @('Get-WidgetA', 'Get-WidgetB')
        }
        $text = [System.IO.File]::ReadAllText($manifest)
        $text | Should -BeExactly $expected
        $text | Should -Not -Match 'private/'
    }

    It 'writes the explicit manifest canonically: UTF-8 without BOM, LF, one trailing newline' {
        $path = New-WidgetModule 'CanonicalWidget'
        $manifest = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } {
            param($P) New-DynamicManifest -ModulePath $P -NestedModule 'CanonicalWidget.ps1' -FunctionToExport 'Get-WidgetA'
        }
        $bytes = [System.IO.File]::ReadAllBytes($manifest)
        $bytes[0] | Should -Not -Be 0xEF
        $bytes | Should -Not -Contain ([byte]13)
        $text = [System.IO.File]::ReadAllText($manifest)
        $text.EndsWith("`n") | Should -BeTrue
        $text.EndsWith("`n`n") | Should -BeFalse
    }

    It 'honours -ExportPrivates with explicit lists (exports every function)' {
        $path = New-WidgetModule 'ExportAllWidget'
        $manifest = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } {
            param($P) New-DynamicManifest -ModulePath $P -NestedModule 'ExportAllWidget.ps1' -FunctionToExport 'Get-WidgetA' -ExportPrivates
        }
        [System.IO.File]::ReadAllText($manifest) | Should -Match "FunctionsToExport = @\('\*'\)"
    }

    It 'writes only on drift (an unchanged manifest is not rewritten)' {
        $path = New-WidgetModule 'DriftWidget'
        $manifest = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } {
            param($P) New-DynamicManifest -ModulePath $P -NestedModule 'DriftWidget.ps1' -FunctionToExport 'Get-WidgetA'
        }
        $stamp = [datetime]'2000-01-01'
        [System.IO.File]::SetLastWriteTimeUtc($manifest, $stamp)
        InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } {
            param($P) New-DynamicManifest -ModulePath $P -NestedModule 'DriftWidget.ps1' -FunctionToExport 'Get-WidgetA'
        } | Out-Null
        [System.IO.File]::GetLastWriteTimeUtc($manifest) | Should -Be $stamp
    }

    It 'requires both explicit lists together' {
        $path = New-WidgetModule 'HalfWidget'
        { InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } { param($P) New-DynamicManifest -ModulePath $P -NestedModule 'HalfWidget.ps1' } } |
            Should -Throw
    }
}

Describe 'New-DynamicManifest explicit lists load a merged module' -Tag 'L1', 'logic' {
    # A merged module — every function in one <Module>.ps1 — loads through its explicit manifest with only the
    # listed publics exported and the private still callable from them (shared module scope).
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
        $script:moduleName = 'GadgetMerged' + [guid]::NewGuid().ToString('N').Substring(0, 8)
        $script:path = Join-Path $TestDrive $moduleName
        [System.IO.Directory]::CreateDirectory($path) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $path "$moduleName.ps1"), ((@("function Get-GadgetPart { 'part' }", 'function Get-Gadget { Get-GadgetPart }') -join "`n") + "`n"))
        $manifest = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path; N = $moduleName } {
            param($P, $N) New-DynamicManifest -ModulePath $P -NestedModule "$N.ps1" -FunctionToExport 'Get-Gadget'
        }
        $script:module = Import-Module $manifest -PassThru -Force
    }

    AfterAll {
        Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'exports only the listed functions' {
        @($module.ExportedFunctions.Keys) | Should -Be @('Get-Gadget')
    }

    It 'keeps the unlisted function private yet callable from an exported one' {
        & $module { Get-Gadget } | Should -Be 'part'
    }
}

# source-only: Test-BuildArtifact builds from the source tree, then checks the manifests the build wrote.
Describe 'Get-DynamicManifestContent is formatter-stable' -Tag 'L2', 'integrity', 'source-only' {
    It 'Invoke-Formatter leaves every built manifest byte-for-byte unchanged (Test-BuildArtifact)' {
        # The published manifest is a versioned immutable artifact, so its canonical form must equal what the
        # repo formatter would produce — otherwise a later touch would re-format and churn the gold bytes. Every
        # <Module>.psd1 in a build comes from Get-DynamicManifestContent (New-DynamicManifest).
        $result = Test-BuildArtifact -Facet Manifest -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Modules | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
