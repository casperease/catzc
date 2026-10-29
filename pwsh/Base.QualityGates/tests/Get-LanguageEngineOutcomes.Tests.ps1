Describe 'Get-LanguageEngineOutcomes' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:cases = @(
            [pscustomobject]@{ Key = 'widget_pkg test_spins'; Name = 'test_spins'; Package = 'widget_pkg'; Title = 'spins' },
            [pscustomobject]@{ Key = 'widget_pkg test_jams'; Name = 'test_jams'; Package = 'widget_pkg'; Title = 'jams' }
        )
        # An engine process that imports this entry finds a stand-in bridge module that answers with the engine it ran under.
        $script:goodEntry = Join-Path $TestDrive 'good-entry.ps1'
        Set-Content -LiteralPath $script:goodEntry -Value @'
$null = New-Module -Name Catzc.Base.QualityGates -ScriptBlock {
    function Get-LanguageTestOutcomes {
        param($Language, $Module, $Case, $EntryScript, $Executable, $Engine, $EngineExecutable, $Folder)
        $outcomes = @{}
        foreach ($item in $Case) {
            $outcomes[$item.Key] = [pscustomobject]@{ Outcome = 'pass'; Reason = "$Engine|$EngineExecutable|$Executable"; Message = '' }
        }
        $outcomes
    }
} | Import-Module -Global
'@
        $script:badEntry = Join-Path $TestDrive 'bad-entry.ps1'
        Set-Content -LiteralPath $script:badEntry -Value "throw 'the widget engine would not start'"
        function Invoke-EngineOutcomes {
            param([string[]] $Engine, [hashtable] $EngineExecutable = @{}, [string] $Executable = 'C:\widget\uv.exe',
                [string] $EntryScript)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Engine = $Engine; EngineExecutable = $EngineExecutable
                Executable = $Executable; EntryScript = $EntryScript; Case = $script:cases
            } {
                param($Engine, $EngineExecutable, $Executable, $EntryScript, $Case)
                Get-LanguageEngineOutcomes -Language 'python' -Module 'Catzc.Widget' -Case $Case -Engine $Engine `
                    -EngineExecutable $EngineExecutable -Executable $Executable -EntryScript $EntryScript
            }
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'timeouts' } {
            [pscustomobject]@{ tests = [pscustomobject]@{ run_list_seconds = 120 } }
        }
        Mock Get-LanguageTestOutcomes -ModuleName Catzc.Base.QualityGates {
            if ($Engine -eq 'zsh') {
                throw 'the widget zsh run broke'
            }
            @{ 'widget_pkg test_spins' = [pscustomobject]@{ Outcome = 'pass'; Reason = "in-process $Engine"; Message = '' } }
        }
    }

    It 'runs a lone engine in this session and returns its outcomes with no error' {
        $runs = Invoke-EngineOutcomes -Engine 'pwsh'
        $runs['pwsh'].Error | Should -Be ''
        $runs['pwsh'].Outcomes['widget_pkg test_spins'].Reason | Should -Be 'in-process pwsh'
        Should -Invoke Get-LanguageTestOutcomes -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'keeps a run that throws as its error, with no outcomes, and runs the others' {
        $runs = Invoke-EngineOutcomes -Engine 'pwsh', 'zsh'
        $runs['zsh'].Error | Should -Be 'the widget zsh run broke'
        $runs['zsh'].Outcomes.Count | Should -Be 0
        $runs['pwsh'].Error | Should -Be ''
    }

    It 'runs an engine with no located executable in this session, where it skips' {
        $runs = Invoke-EngineOutcomes -Engine 'pwsh', 'bash'
        $runs['bash'].Outcomes['widget_pkg test_spins'].Reason | Should -Be 'in-process bash'
        Should -Invoke Get-LanguageTestOutcomes -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly
    }

    It 'runs an engine with an executable in a process of its own, its tool and folder handed over' {
        $runs = Invoke-EngineOutcomes -Engine 'pwsh', 'bash', 'zsh' -EntryScript $script:goodEntry -EngineExecutable @{
            bash = 'C:\widget\bash.exe'; zsh = 'C:\widget\zsh.exe'
        }
        $runs['pwsh'].Outcomes['widget_pkg test_spins'].Reason | Should -Be 'in-process pwsh'
        $runs['bash'].Error | Should -Be ''
        $runs['bash'].Outcomes['widget_pkg test_jams'].Reason | Should -Be 'bash|C:\widget\bash.exe|C:\widget\uv.exe'
        $runs['zsh'].Outcomes['widget_pkg test_jams'].Reason | Should -Be 'zsh|C:\widget\zsh.exe|C:\widget\uv.exe'
        Should -Invoke Get-LanguageTestOutcomes -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'keeps an engine process that cannot start as that engine''s error' {
        $runs = Invoke-EngineOutcomes -Engine 'pwsh', 'bash' -EntryScript $script:badEntry -EngineExecutable @{ bash = 'C:\widget\bash.exe' }
        $runs['bash'].Error | Should -BeLike '*the widget engine would not start*'
        $runs['bash'].Outcomes.Count | Should -Be 0
        $runs['pwsh'].Error | Should -Be ''
    }
}
