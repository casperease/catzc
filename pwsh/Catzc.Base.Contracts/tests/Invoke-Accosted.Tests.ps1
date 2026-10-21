<#
---
catzc:
  immutable:
    with_body_sha: acfc7778624c
  edges:
    code: pwsh/Catzc.Base.Contracts/Invoke-Accosted.ps1
---
#>

Describe 'Invoke-Accosted' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $script:file = [Catzc.Base.Contracts.AccostedFile]::new([ordered]@{
                runs = @(
                    , @([ordered]@{ get_widget = [ordered]@{ widget_path = "a b's"; depth = 2; strict = $true } }, [ordered]@{ test_gadget = [ordered]@{ quiet = $false } })
                    , @([ordered]@{ get_widget = [ordered]@{ widget_path = 'c' } })
                )
            })
        $script:contract = {
            param([string] $Name, [hashtable] $Specs)
            [pscustomobject]@{ Name = $Name; parameters = @(foreach ($key in $Specs.Keys) {
                        [Catzc.Base.Contracts.ContractParameter]::Parse($key, $Specs[$key])
                    })
            }
        }
    }

    BeforeEach {
        $script:calls = [System.Collections.Generic.List[object]]::new()
        Mock Get-AccostedFile -ModuleName Catzc.Base.Contracts { $script:file }
        Mock Get-CommandContract -ModuleName Catzc.Base.Contracts {
            & $script:contract 'get_widget' @{ widget_path = 'string!'; depth = 'int'; strict = 'switch' }
            & $script:contract 'test_gadget' @{ quiet = 'bool' }
        }
        Mock Get-Config -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'timeouts' } { [pscustomobject]@{ tests = @{ run_list_seconds = 42 } } }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.Contracts { "C:\widget\$Engine.exe" }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.Contracts -ParameterFilter { $Engine -eq 'zsh' } { throw 'The zsh engine was not found.' }
        Mock Invoke-Executable -ModuleName Catzc.Base.Contracts {
            $script:calls.Add([pscustomobject]@{ Command = $Command; Timeout = $TimeoutSeconds })
            [pscustomobject]@{ ExitCode = ($Command -clike "*WidgetPath 'c'*" ? 1 : 0); Full = 'widget output' }
        }
    }

    It 'renders each run in the idiom of each engine, the commands chained with &&' {
        $results = @(Invoke-Accosted -Path 'widgets.accosted.yml' -Engine pwsh, bash -RepositoryRoot $script:root)
        $results.Count | Should -Be 4
        $results[0].Command | Should -BeExactly "Get-Widget -WidgetPath 'a b''s' -Depth 2 -Strict && Test-Gadget -Quiet `$false"
        $results[2].Engine | Should -Be 'bash'
        $results[2].Command | Should -BeExactly "get-widget --widget-path 'a b'\''s' --depth 2 --strict && cats test-gadget --quiet false"
    }

    It 'bounds every run by the configured run-list limit, and passes a run exactly when its engine exits 0' {
        $results = @(Invoke-Accosted -Path 'widgets.accosted.yml' -Engine pwsh -RepositoryRoot $script:root)
        @($script:calls | ForEach-Object Timeout) | Should -Be @(42, 42)
        $results[0].Passed | Should -BeTrue
        $results[1].Passed | Should -BeFalse
        $results[1].ExitCode | Should -Be 1
    }

    It 'quotes the engine start into one command line, the entry sourced first' {
        $null = Invoke-Accosted -Path 'widgets.accosted.yml' -Engine bash -RepositoryRoot $script:root
        $script:calls[0].Command | Should -BeLike '"C:\widget\bash.exe" *importer.sh*get-widget*'
    }

    It 'fails every run of an engine that is not installed, without starting it' {
        $results = @(Invoke-Accosted -Path 'widgets.accosted.yml' -Engine zsh -RepositoryRoot $script:root)
        $results.Count | Should -Be 2
        @($results | Where-Object Passed).Count | Should -Be 0
        $results[0].Output | Should -BeLike '*zsh engine was not found*'
        $script:calls.Count | Should -Be 0
    }
}
