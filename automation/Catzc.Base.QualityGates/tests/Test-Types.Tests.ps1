# Test-Types is the C# namespace gate: every type source declares the file-scoped namespace of its module folder,
# ending through Write-QualityGateReport ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
# A fixture tree in $TestDrive stands in for the repository (neutral widget/gadget names,
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the real tree is gated by the
# integrity test in Import-CSharpTypes.Tests.ps1.
Describe 'Test-Types' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:writeType = {
            param([string] $Root, [string] $Module, [string] $Name, [string] $Text)
            $folder = Join-Path $Root "automation/$Module/types"
            [void][System.IO.Directory]::CreateDirectory($folder)
            [System.IO.File]::WriteAllText((Join-Path $folder "$Name.cs"), $Text)
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:reportBase = Join-Path $script:root 'reports'
        $repositoryRoot = $script:root
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates -MockWith { $repositoryRoot }.GetNewClosure()
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        & $writeType $script:root 'Catzc.Widget' 'Widget' ('namespace Catzc.Widget;', '', 'public sealed class Widget { }', '' -join "`n")
    }

    It 'passes when every type declares its module namespace' -Tag 'ADR-AUTO-TEST#35' {
        { Test-Types -Path (Join-Path $script:root 'automation') -OutputFolder $script:reportBase } | Should -Not -Throw
    }

    It 'throws once listing every mismatched, block-scoped, and missing namespace' -Tag 'ADR-AUTO-TEST#35' {
        & $writeType $script:root 'Catzc.Widget' 'Gadget' ('namespace Catzc.Gadget;', '', 'public sealed class Gadget { }', '' -join "`n")
        & $writeType $script:root 'Catzc.Gadget' 'Gizmo' "namespace Catzc.Gadget`n{`n    public sealed class Gizmo { }`n}`n"
        & $writeType $script:root 'Catzc.Gadget' 'Bare' "public sealed class Bare { }`n"
        $thrown = { Test-Types -Path (Join-Path $script:root 'automation') -OutputFolder $script:reportBase } |
            Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-Types failed: 3 issue(s)*'
        $message | Should -Match "automation/Catzc.Widget/types/Gadget.cs: declares namespace 'Catzc.Gadget'"
        $message | Should -Match 'automation/Catzc.Gadget/types/Gizmo.cs: uses a block-scoped namespace'
        $message | Should -Match 'automation/Catzc.Gadget/types/Bare.cs: declares no namespace'
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        & $writeType $script:root 'Catzc.Gadget' 'Bare' "public sealed class Bare { }`n"
        $result = Test-Types -Path (Join-Path $script:root 'automation') -OutputFolder $script:reportBase -PassThru
        $result.Subject | Should -Be 'types'
        $result.IssueCount | Should -Be 1
        $result.FileCount | Should -Be 2
        $result.Issues | Should -BeLike '*Bare.cs: declares no namespace*run Format-Types*'
        Test-Path (Join-Path $result.ReportPath 'types.md') | Should -BeTrue
    }
}
