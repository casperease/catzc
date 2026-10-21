<#
---
catzc:
  immutable:
    with_body_sha: "7191c3e17365"
  edges:
    code: pwsh/Catzc.Base.Contracts/types/AccostedFile.cs
---
#>

Describe 'AccostedFile' -Tag 'L0', 'logic' {
    It 'reads runs of commands, each a normal-form name and its literal arguments, in the order written' {
        $file = [Catzc.Base.Contracts.AccostedFile]::new([ordered]@{
                runs = @(
                    , @([ordered]@{ get_widget = [ordered]@{ path = 'widgets/a.wdg'; depth = 2 } }, [ordered]@{ test_gadget = $null })
                    , @([ordered]@{ find_sprocket = [ordered]@{ names = @('a', 'b'); all = $true } })
                )
            })
        $file.runs.Count | Should -Be 2
        $file.runs[0].commands.name | Should -Be @('get_widget', 'test_gadget')
        $file.runs[0].commands[0].arguments['path'] | Should -Be 'widgets/a.wdg'
        $file.runs[0].commands[0].arguments['depth'] | Should -Be 2
        $file.runs[0].commands[1].arguments.Count | Should -Be 0
        $file.runs[1].commands[0].arguments['names'] | Should -Be @('a', 'b')
        $file.runs[1].commands[0].arguments['all'] | Should -BeTrue
    }

    It 'rejects <Case>, naming where' -ForEach @(
        @{ Case = 'a document without runs'; Raw = [ordered]@{ steps = @() }; Message = '*has one key, runs*' }
        @{ Case = 'a second key'; Raw = [ordered]@{ runs = @(, @([ordered]@{ get_widget = $null })); name = 'x' }; Message = '*has one key, runs*' }
        @{ Case = 'no run'; Raw = [ordered]@{ runs = @() }; Message = '*at least one run*' }
        @{ Case = 'an empty run'; Raw = [ordered]@{ runs = @(, @()) }; Message = '*run 1: a run holds at least one command*' }
        @{ Case = 'a run that is a mapping'; Raw = [ordered]@{ runs = @([ordered]@{ get_widget = $null }) }; Message = '*run 1: a run is a list*' }
        @{ Case = 'two commands in one mapping'; Raw = [ordered]@{ runs = @(, @([ordered]@{ get_widget = $null; get_gadget = $null })) }; Message = '*run 1, command 1: a command is one mapping*' }
        @{ Case = 'a name not in the normal form'; Raw = [ordered]@{ runs = @(, @([ordered]@{ 'Get-Widget' = $null })) }; Message = "*'Get-Widget' is not a command name*" }
        @{ Case = 'an argument name not in the normal form'; Raw = [ordered]@{ runs = @(, @([ordered]@{ get_widget = [ordered]@{ Path = 'a' } })) }; Message = "*'Path' of 'get_widget'*" }
        @{ Case = 'a mapping argument'; Raw = [ordered]@{ runs = @(, @([ordered]@{ get_widget = [ordered]@{ spec = [ordered]@{ a = 1 } } })) }; Message = "*'spec' of 'get_widget' is a mapping*" }
        @{ Case = 'a nested list'; Raw = [ordered]@{ runs = @(, @([ordered]@{ get_widget = [ordered]@{ names = @(, @('a')) } })) }; Message = "*'names' of 'get_widget' nests*" }
    ) {
        { [Catzc.Base.Contracts.AccostedFile]::new($Raw) } | Should -Throw $Message
    }
}
