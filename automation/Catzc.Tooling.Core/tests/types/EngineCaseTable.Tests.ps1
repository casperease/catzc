<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/tests/types/EngineCaseTable.Tests.ps1
    folder: tests/types
    name: engine-case-table-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'EngineCaseTable' -Tag 'L0', 'logic' {
    BeforeAll {
        function script:New-EngineCaseTable {
            param([System.Collections.IDictionary] $Data)
            [Catzc.Tooling.Core.EngineCaseTable]::new($Data)
        }
    }

    It 'reads one row per case and engine, in file order, with fields or the n/a reason' {
        $table = New-EngineCaseTable ([ordered]@{
                subject = 'widget start'
                cases   = @(
                    [ordered]@{ case = 'starts'; pwsh = @{ command = 'Start-Widget' }; bash = @{ command = 'start-widget' }; zsh = @{ command = 'start-widget' } }
                    [ordered]@{ case = 'pwsh only'; pwsh = @{ command = 'Get-Gadget' }; bash = 'n/a: bash has no gadget'; zsh = 'n/a: zsh has no gadget' }
                )
            })
        $table.Subject | Should -Be 'widget start'
        $table.Cases | Should -Be @('starts', 'pwsh only')
        $table.Rows.Count | Should -Be 6
        $table.Rows[0].engine | Should -Be 'pwsh'
        $table.Rows[1].fields.command | Should -Be 'start-widget'
        $table.Rows[4].not_applicable | Should -Be 'bash has no gadget'
        $table.Rows[4].fields | Should -BeNullOrEmpty
        $table.Rows[5].engine | Should -Be 'zsh'
        $table.Rows[5].not_applicable | Should -Be 'zsh has no gadget'
    }

    It 'takes its columns from the execution engine model, in its order' {
        $table = [Catzc.Tooling.Core.EngineCaseTable]::new(@{ subject = 'w'; cases = @(@{ case = 'c'; pwsh = @{ a = 1 }; bash = @{ a = 1 }; zsh = @{ a = 1 } }) })
        @($table.Rows | ForEach-Object { $_.engine }) | Should -Be @([Catzc.Base.Engines.ExecutionEngines]::Names)
    }

    It 'throws on <problem>' -ForEach @(
        @{ problem = 'a missing engine column'; data = @{ subject = 'w'; cases = @(@{ case = 'c'; pwsh = @{ a = 1 }; zsh = @{ a = 1 } }) }; expected = "*case 'c': the bash column must be a map*" }
        @{ problem = 'an n/a without a reason'; data = @{ subject = 'w'; cases = @(@{ case = 'c'; pwsh = @{ a = 1 }; bash = 'n/a:'; zsh = @{ a = 1 } }) }; expected = "*case 'c': the bash column*" }
        @{ problem = 'a plain string column'; data = @{ subject = 'w'; cases = @(@{ case = 'c'; pwsh = 'start-widget'; bash = @{ a = 1 }; zsh = @{ a = 1 } }) }; expected = "*case 'c': the pwsh column*" }
        @{ problem = 'an unknown engine column'; data = @{ subject = 'w'; cases = @(@{ case = 'c'; pwsh = @{ a = 1 }; bash = @{ a = 1 }; zsh = @{ a = 1 }; widget = @{ a = 1 } }) }; expected = "*unknown key 'cases[[]0].widget'*" }
        @{ problem = 'a duplicate case'; data = @{ subject = 'w'; cases = @(@{ case = 'c'; pwsh = @{ a = 1 }; bash = @{ a = 1 }; zsh = @{ a = 1 } }, @{ case = 'c'; pwsh = @{ a = 1 }; bash = @{ a = 1 }; zsh = @{ a = 1 } }) }; expected = "*duplicate case 'c'*" }
        @{ problem = 'a case without a name'; data = @{ subject = 'w'; cases = @(@{ pwsh = @{ a = 1 }; bash = @{ a = 1 }; zsh = @{ a = 1 } }) }; expected = '*missing case*' }
        @{ problem = 'no subject'; data = @{ cases = @(@{ case = 'c'; pwsh = @{ a = 1 }; bash = @{ a = 1 }; zsh = @{ a = 1 } }) }; expected = '*missing subject*' }
        @{ problem = 'no cases'; data = @{ subject = 'w'; cases = @() }; expected = '*missing cases*' }
        @{ problem = 'an unknown top-level key'; data = @{ subject = 'w'; cases = @(@{ case = 'c'; pwsh = @{ a = 1 }; bash = @{ a = 1 }; zsh = @{ a = 1 } }); engines = 'x' }; expected = "*unknown key 'engines'*" }
    ) {
        { New-EngineCaseTable $data } | Should -Throw $expected
    }

    It 'throws on an empty table' {
        { New-EngineCaseTable $null } | Should -Throw '*the table is empty*'
    }
}
