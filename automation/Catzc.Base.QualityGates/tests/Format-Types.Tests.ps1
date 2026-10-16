<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
    folder: tests
    name: format-types-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Format-Types.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#{3,35}
---
#>

Describe 'Format-Types' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:writeType = {
            param([string] $Root, [string] $Module, [string] $Name, [string] $Text)
            $folder = Join-Path $Root "automation/$Module/types"
            [void][System.IO.Directory]::CreateDirectory($folder)
            $file = Join-Path $folder "$Name.cs"
            [System.IO.File]::WriteAllText($file, $Text)
            $file
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        $script:widget = & $writeType $script:root 'Catzc.Widget' 'Widget' ('namespace Catzc.Widget;', '', 'public sealed class Widget { }', '' -join "`n")
    }

    It 'leaves a source that declares its module namespace unchanged' {
        $result = Format-Types -Path (Join-Path $script:root 'automation') -DryRun -PassThru
        $result.ChangedCount | Should -Be 0
        $result.BlockScopedFiles | Should -BeNullOrEmpty
    }

    It 'reports a mismatched and a missing namespace under -DryRun without writing them' {
        $mismatched = & $writeType $script:root 'Catzc.Widget' 'Gadget' ('namespace Catzc.Gadget;', '', 'public sealed class Gadget { }', '' -join "`n")
        $missing = & $writeType $script:root 'Catzc.Gadget' 'Bare' "public sealed class Bare { }`n"

        $result = Format-Types -Path (Join-Path $script:root 'automation') -DryRun -PassThru
        $result.ChangedFiles | Sort-Object | Should -Be (@($mismatched, $missing) | Sort-Object)
        [System.IO.File]::ReadAllText($missing) | Should -Be "public sealed class Bare { }`n"
    }

    It 'writes the module namespace without -DryRun' {
        $mismatched = & $writeType $script:root 'Catzc.Widget' 'Gadget' ('namespace Catzc.Gadget;', '', 'public sealed class Gadget { }', '' -join "`n")

        Format-Types -Path (Join-Path $script:root 'automation') | Out-Null
        [System.IO.File]::ReadAllText($mismatched) | Should -BeLike 'namespace Catzc.Widget;*'
    }

    It 'reports a block-scoped namespace in BlockScopedFiles and leaves it untouched' {
        $text = "namespace Catzc.Gadget`n{`n    public sealed class Gizmo { }`n}`n"
        $blockScoped = & $writeType $script:root 'Catzc.Gadget' 'Gizmo' $text

        $result = Format-Types -Path (Join-Path $script:root 'automation') -PassThru
        $result.BlockScopedFiles | Should -Be @($blockScoped)
        $result.ChangedFiles | Should -BeNullOrEmpty
        [System.IO.File]::ReadAllText($blockScoped) | Should -Be $text
    }
}
