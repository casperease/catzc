<#
---
catzc:
  derived:
    path: automation/.internal/tests/Get-DynamicManifestContent.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/internal/tests/Get-DynamicManifestContent.Tests.ps1.md
---
#>

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

    It 'renders -ModuleFile as the PrivateData file list, in the order given' {
        $text = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('loader.ps1') -ModuleFile @('private/B.ps1', 'A.ps1') -FunctionToExport @('A') }
        $text | Should -Match "PrivateData       = @\{ CatzcFiles = @\('private/B\.ps1', 'A\.ps1'\) \}"
        $data = [scriptblock]::Create($text).InvokeReturnAsIs()
        @($data.PrivateData.CatzcFiles) | Should -Be @('private/B.ps1', 'A.ps1')
    }

    It 'leaves PrivateData out when there is no file list' {
        $text = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('A.ps1') -FunctionToExport @('A') }
        $text | Should -Not -Match 'PrivateData'
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

    It 'derives the file list from the folder by default (private first, each group ordinal-sorted), loaded by the shared loader' {
        $path = New-WidgetModule 'DerivedWidget'
        $manifest = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } { param($P) New-DynamicManifest -ModulePath $P }
        $expected = InModuleScope Catzc.Internal.Bootstrap {
            Get-DynamicManifestContent -NestedModule @('../.internal/assets/Import-ModuleFiles.ps1') `
                -ModuleFile @('private/Get-WidgetPart.ps1', 'Get-WidgetA.ps1', 'Get-WidgetB.ps1') -FunctionToExport @('Get-WidgetA', 'Get-WidgetB')
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

Describe 'New-DynamicManifest derived manifests load through the shared loader' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
        $script:modulesRoot = Join-Path $TestDrive 'automation'
        [System.IO.Directory]::CreateDirectory((Join-Path $modulesRoot '.internal/assets')) | Out-Null
        [System.IO.File]::Copy((Join-Path $env:RepositoryRoot 'automation/.internal/assets/Import-ModuleFiles.ps1'), (Join-Path $modulesRoot '.internal/assets/Import-ModuleFiles.ps1'))

        function New-SprocketModule {
            param([string] $Name, [hashtable] $File)
            $path = Join-Path $modulesRoot $Name
            foreach ($relative in $File.Keys) {
                $target = Join-Path $path $relative
                [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target)) | Out-Null
                [System.IO.File]::WriteAllText($target, $File[$relative])
            }
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ P = $path } { param($P) New-DynamicManifest -ModulePath $P }
        }

        $script:moduleName = 'SprocketDerived' + [guid]::NewGuid().ToString('N').Substring(0, 8)
        $manifest = New-SprocketModule $moduleName @{
            'private/Get-SprocketPart.ps1' = "function Get-SprocketPart { 'part' }"
            'Get-Sprocket.ps1'             = 'function Get-Sprocket { Get-SprocketPart }'
            'Get-SprocketFailure.ps1'      = "function Get-SprocketFailure {`n    `$null = 1`n    throw 'sprocket broke'`n}"
        }
        $script:module = Import-Module $manifest -PassThru -Force
    }

    AfterAll {
        Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'exports the public functions only' {
        @($module.ExportedFunctions.Keys | Sort-Object) | Should -Be @('Get-Sprocket', 'Get-SprocketFailure')
    }

    It 'makes a private function callable from a public one, in the module only' {
        & $module { Get-Sprocket } | Should -Be 'part'
        Get-Command Get-SprocketPart -ErrorAction Ignore | Should -BeNullOrEmpty
    }

    It 'keeps each function''s source file and line' {
        [System.IO.Path]::GetFileName($module.ExportedFunctions['Get-Sprocket'].ScriptBlock.File) | Should -Be 'Get-Sprocket.ps1'
        $failure = { & $module { Get-SprocketFailure } } | Should -Throw -PassThru
        ("$($failure.ScriptStackTrace)" -split '\r?\n')[0] | Should -BeLike "at Get-SprocketFailure, *$moduleName*Get-SprocketFailure.ps1: line 3"
    }

    It 'leaves none of the loader''s variables in the module' {
        & $module { @(Get-Variable -Name 'catzc*' -Scope Script -ErrorAction Ignore).Count } | Should -Be 0
    }

    It 'fails the import on a syntax error, naming the file and line' {
        $brokenName = 'SprocketBroken' + [guid]::NewGuid().ToString('N').Substring(0, 8)
        $brokenManifest = New-SprocketModule $brokenName @{ 'Get-SprocketBroken.ps1' = "function Get-SprocketBroken {`n    if (`n}" }
        { Import-Module $brokenManifest -Force } | Should -Throw -ExpectedMessage '*Get-SprocketBroken.ps1:*'
        Remove-Module $brokenName -Force -ErrorAction SilentlyContinue
    }
}

# source-only: Test-BuildArtifact builds from the source tree, then checks the manifests the build wrote.
Describe 'Get-DynamicManifestContent is formatter-stable' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'Invoke-Formatter leaves every built manifest byte-for-byte unchanged (Test-BuildArtifact)' {
        $result = Test-BuildArtifact -Facet Manifest -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Modules | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'Invoke-Formatter leaves a derived manifest (the shared loader and its file list) byte-for-byte unchanged' {
        $text = InModuleScope Catzc.Internal.Bootstrap {
            Get-DynamicManifestContent -NestedModule @('../.internal/assets/Import-ModuleFiles.ps1') `
                -ModuleFile @('private/Get-WidgetPart.ps1', 'Get-WidgetA.ps1') -FunctionToExport @('Get-WidgetA')
        }
        Invoke-Formatter -ScriptDefinition $text | Should -BeExactly $text
    }
}
