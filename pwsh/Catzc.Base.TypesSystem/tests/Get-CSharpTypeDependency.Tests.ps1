<#
---
catzc:
  immutable:
    with_body_sha: bd16710f0437
  edges:
    docs: "[Get-CSharpTypeDependency.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-types-system/tests/Get-CSharpTypeDependency.Tests.ps1.md)"
    code: pwsh/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
    cites:
      - ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS
---
#>

# Source-tree tooling (Assert-SourceTree): its scans need the per-module types/*.cs, so this test file is source-only.
Describe 'Get-CSharpTypeDependency' -Tag 'L0', 'source-only' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))

        function New-TypeModule {
            param([string] $Module, [hashtable] $Files)
            # The resolver names the modules; the fixture's module folders under $root stand in for the code track.
            $fixtureRoot = $root
            Mock Get-CatzcModule -ModuleName Catzc.Base.TypesSystem -MockWith {
                foreach ($dir in [System.IO.Directory]::EnumerateDirectories($fixtureRoot)) {
                    $moduleName = [System.IO.Path]::GetFileName($dir)
                    [Catzc.Base.Modules.Module]::new($moduleName, 'widgets', 'widget-folder', 'widgetry', "widgetry/$moduleName", 'folder', $null, $null, $null, $null)
                }
            }.GetNewClosure()
            $td = Join-Path $root "$Module/types"
            [System.IO.Directory]::CreateDirectory($td) | Out-Null
            foreach ($name in $Files.Keys) {
                [System.IO.File]::WriteAllText((Join-Path $td "$name.cs"), $Files[$name])
            }
        }
    }

    It 'reports an edge for a cross-module type reference' -Tag 'logic' {
        New-TypeModule 'Catzc.Base' @{ Rec = 'public abstract class Rec { }' }
        New-TypeModule 'Catzc.Consumer' @{ Thing = 'public class Thing : Catzc.Base.Rec { }' }

        $edges = @(Get-CSharpTypeDependency -ModulesRoot $root)
        $e = $edges | Where-Object { $_.From -eq 'Catzc.Consumer' }
        $e.To | Should -Be 'Catzc.Base'
    }

    It 'maps a token to its LONGEST module prefix (Catzc.Azure.Templates, not Catzc.Azure)' -Tag 'logic' {
        New-TypeModule 'Catzc.Azure' @{ Ctx = 'public class Ctx { }' }
        New-TypeModule 'Catzc.Azure.Templates' @{ Template = 'public class Template { }' }
        New-TypeModule 'Catzc.OnlyTemplates' @{ Use = 'public class Use { public Catzc.Azure.Templates.Template T; }' }

        $edges = @(Get-CSharpTypeDependency -ModulesRoot $root)
        $from = @($edges | Where-Object { $_.From -eq 'Catzc.OnlyTemplates' })
        @($from.To) | Should -Be @('Catzc.Azure.Templates')   # exactly one edge — NOT also Catzc.Azure
    }

    It 'ignores references that appear only in comments or string literals' -Tag 'logic' {
        New-TypeModule 'Catzc.Commented' @{ Note = 'public class Note { }' }
        New-TypeModule 'Catzc.Base' @{ Rec = 'public class Rec { }' }
        New-TypeModule 'Catzc.Consumer' @{
            Thing = @'
// see Catzc.Commented.Note for history
public class Thing : Catzc.Base.Rec {
    public string s = "Catzc.Commented.Note";
}
'@
        }

        $edges = @(Get-CSharpTypeDependency -ModulesRoot $root)
        @($edges | Where-Object { $_.To -eq 'Catzc.Commented' }) | Should -BeNullOrEmpty
        ($edges | Where-Object { $_.From -eq 'Catzc.Consumer' }).To | Should -Be 'Catzc.Base'
    }

    It 'drops self-references and BCL tokens' -Tag 'logic' {
        New-TypeModule 'Catzc.Solo' @{
            Thing = 'public class Thing { public Catzc.Solo.Thing Self; public System.Collections.Generic.List<int> L; }'
        }

        $edges = @(Get-CSharpTypeDependency -ModulesRoot $root)
        $edges | Should -BeNullOrEmpty   # own-module ref and System.* produce no cross-module edges
    }

    It 'de-duplicates repeated references and lists each once' -Tag 'logic' {
        New-TypeModule 'Catzc.Base' @{ Rec = 'public class Rec { }' }
        New-TypeModule 'Catzc.Consumer' @{
            Thing = 'public class Thing { public Catzc.Base.Rec A; public Catzc.Base.Rec B; }'
        }

        $edges = @(Get-CSharpTypeDependency -ModulesRoot $root)
        $e = $edges | Where-Object { $_.From -eq 'Catzc.Consumer' }
        @($e.References).Count | Should -Be 1   # Catzc.Base.Rec referenced twice, listed once
    }

    # L1: scans every shipped module's types/*.cs, so its cost grows with the repo, not with the logic.
    Context 'integrity (real repo)' -Tag 'L1', 'integrity' {
        It 'scans the shipped types without error' {
            { Get-CSharpTypeDependency } | Should -Not -Throw
        }
    }
}

Describe 'Get-CSharpTypeDependency — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Get-CSharpTypeDependency -ModulesRoot $TestDrive } | Should -Throw '*Get-CSharpTypeDependency operates on the catzc source tree*'
    }
}
