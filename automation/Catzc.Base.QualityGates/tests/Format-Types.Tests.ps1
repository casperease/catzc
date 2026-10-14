# Format-Types maintains each C# type source's file-scoped namespace from its module folder; its -DryRun is the C#
# part of Test-Formatting ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
# A fixture tree in $TestDrive stands in for the repository (neutral widget/gadget names,
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the real tree is checked by the
# formatting integrity test in Test-Formatting.Tests.ps1.
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
