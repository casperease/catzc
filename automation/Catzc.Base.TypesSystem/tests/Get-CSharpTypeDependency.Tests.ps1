Describe 'Get-CSharpTypeDependency' -Tag 'L0' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))

        # Writes <root>/<module>/types/<type>.cs for each entry. Module names double as namespaces.
        # [System.IO] rather than New-Item/Set-Content — ~0.1ms vs ~20ms/call (ADR-TEST:18).
        function New-TypeModule {
            param([string] $Module, [hashtable] $Files)
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

        $edges = @(Get-CSharpTypeDependency -AutomationRoot $root)
        $e = $edges | Where-Object { $_.From -eq 'Catzc.Consumer' }
        $e.To | Should -Be 'Catzc.Base'
    }

    It 'maps a token to its LONGEST module prefix (Catzc.Azure.Templates, not Catzc.Azure)' -Tag 'logic' {
        New-TypeModule 'Catzc.Azure' @{ Ctx = 'public class Ctx { }' }
        New-TypeModule 'Catzc.Azure.Templates' @{ Template = 'public class Template { }' }
        New-TypeModule 'Catzc.OnlyTemplates' @{ Use = 'public class Use { public Catzc.Azure.Templates.Template T; }' }

        $edges = @(Get-CSharpTypeDependency -AutomationRoot $root)
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

        $edges = @(Get-CSharpTypeDependency -AutomationRoot $root)
        @($edges | Where-Object { $_.To -eq 'Catzc.Commented' }) | Should -BeNullOrEmpty
        ($edges | Where-Object { $_.From -eq 'Catzc.Consumer' }).To | Should -Be 'Catzc.Base'
    }

    It 'drops self-references and BCL tokens' -Tag 'logic' {
        New-TypeModule 'Catzc.Solo' @{
            Thing = 'public class Thing { public Catzc.Solo.Thing Self; public System.Collections.Generic.List<int> L; }'
        }

        $edges = @(Get-CSharpTypeDependency -AutomationRoot $root)
        $edges | Should -BeNullOrEmpty   # own-module ref and System.* produce no cross-module edges
    }

    It 'de-duplicates repeated references and lists each once' -Tag 'logic' {
        New-TypeModule 'Catzc.Base' @{ Rec = 'public class Rec { }' }
        New-TypeModule 'Catzc.Consumer' @{
            Thing = 'public class Thing { public Catzc.Base.Rec A; public Catzc.Base.Rec B; }'
        }

        $edges = @(Get-CSharpTypeDependency -AutomationRoot $root)
        $e = $edges | Where-Object { $_.From -eq 'Catzc.Consumer' }
        @($e.References).Count | Should -Be 1   # Catzc.Base.Rec referenced twice, listed once
    }

    Context 'integrity (real repo)' -Tag 'integrity' {
        It 'scans the shipped types without error' {
            { Get-CSharpTypeDependency } | Should -Not -Throw
        }
    }
}
