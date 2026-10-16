<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Tests.ps1
    folder: tests
    name: get-timeout-seconds-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-PWSH-ASSERT#1
---
#>

Describe 'Get-TimeoutSeconds' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Timeouts {
            [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{
                    limits      = @{
                        devbox   = @{ bash = @{ foreground = 7; background = 70 }; pwsh = 8; zsh = 9 }
                        pipeline = @{ bash = @{ foreground = 60; background = 600 }; pwsh = 80 }
                    }
                    executables = @{ widget = 90 }
                })
        }
        Mock Get-RunEnvironment -ModuleName Catzc.Base.Timeouts { 'Devbox' }
    }

    It "returns the environment's pwsh limit by default" {
        Get-TimeoutSeconds | Should -Be 8
    }

    It 'returns the bash foreground and background limits' {
        Get-TimeoutSeconds -Shell Bash | Should -Be 7
        Get-TimeoutSeconds -Shell Bash -Background | Should -Be 70
    }

    It 'resolves for the pipeline environment' {
        Mock Get-RunEnvironment -ModuleName Catzc.Base.Timeouts { 'Pipeline' }
        Get-TimeoutSeconds | Should -Be 80
        Get-TimeoutSeconds -Shell Bash -Background | Should -Be 600
        Get-TimeoutSeconds -Executable gadget | Should -Be 80
    }

    It "returns an executable's own limit" {
        Get-TimeoutSeconds -Executable 'C:\tools\widget.exe' | Should -Be 90
    }

    It "returns the environment's pwsh limit for an unlisted executable" {
        Get-TimeoutSeconds -Executable gadget | Should -Be 8
    }

    It 'passes -EnvironmentAssertIs to Get-RunEnvironment only when given' {
        Get-TimeoutSeconds -EnvironmentAssertIs Devbox | Should -Be 8
        Should -Invoke Get-RunEnvironment -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $EnvironmentAssertIs -eq 'Devbox' }
        Get-TimeoutSeconds | Should -Be 8
        Should -Invoke Get-RunEnvironment -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { -not $EnvironmentAssertIs }
    }

    It 'returns the zsh limit, one per environment' {
        Get-TimeoutSeconds -Shell zsh | Should -Be 9
        { Get-TimeoutSeconds -Shell zsh -Background } | Should -Throw '*zsh has no background limit*'
    }

    It 'throws on a pwsh background limit' {
        { Get-TimeoutSeconds -Shell Pwsh -Background } | Should -Throw '*pwsh has no background limit*'
    }

    It 'throws, naming the shells, on a shell that is not an execution engine' {
        { Get-TimeoutSeconds -Shell widget } | Should -Throw "*unknown shell 'widget' (allowed: pwsh, bash, zsh)*"
    }

    Context '-Budget' {
        BeforeAll {
            # Fixture GUIDs are built at runtime (not literals), so they need no managed-GUID registry entry.
            $script:widgetBudget = 'a1d6e700-0000-0000-0000-' + '000000000000'
            $script:gadgetBudget = 'ba000500-0000-0000-0000-' + '000000000000'
        }

        BeforeEach {
            Mock Get-Config -ModuleName Catzc.Base.Timeouts -ParameterFilter { $Config -eq 'timeout-exemptions' } {
                [Catzc.Base.Timeouts.TimeoutExemptionsConfig]::new([ordered]@{ ceiling = @{ devbox = @{ pwsh = 300; bash = 50 } } })
            }
        }

        It 'raises an exempt budget to the exemption ceiling' {
            Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { @{ reason = 'tuning' } }
            Get-TimeoutSeconds -Budget $widgetBudget | Should -Be 300
        }

        It 'keeps the normal limit for a budget that is not exempt, or no budget' {
            Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { }
            Get-TimeoutSeconds -Budget $gadgetBudget | Should -Be 8
            Get-TimeoutSeconds -Budget ([guid]::Empty) | Should -Be 8
            Get-TimeoutSeconds | Should -Be 8
            Should -Invoke Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly
        }

        It 'never lowers a limit that is already above the ceiling' {
            Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { @{ reason = 'tuning' } }
            Get-TimeoutSeconds -Shell Bash -Background -Budget $widgetBudget | Should -Be 70
        }
    }

    # A function's own limit, most specific first: exemption, commands entry, decoration, environment default.
    Context '-Command' -Tag 'ADR-PWSH-ASSERT#1' {
        BeforeAll {
            $script:gizmoBudget = 'c0ffee00-0000-0000-0000-' + '000000000000'
            $budget = $script:gizmoBudget
            function global:Sync-Widget {
                [CmdletBinding()]
                [Catzc.Base.Timeouts.TimeLimit(120, Pipeline = 900)]
                param()
            }
            function global:Sync-Gadget {
                [CmdletBinding()]
                param()
            }
            # The decoration's arguments are constants, so the budgeted function's body is built from text.
            $gizmo = [scriptblock]::Create("[CmdletBinding()] [Catzc.Base.Timeouts.TimeLimit(120, Budget = '$budget')] param()")
            Set-Item -Path Function:\global:Sync-Gizmo -Value $gizmo
        }

        AfterAll {
            Remove-Item Function:\Sync-Widget, Function:\Sync-Gadget, Function:\Sync-Gizmo -ErrorAction Ignore
        }

        BeforeEach {
            Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { }
        }

        It 'returns the decoration for this environment' {
            Get-TimeoutSeconds -Command Sync-Widget | Should -Be 120
            Mock Get-RunEnvironment -ModuleName Catzc.Base.Timeouts { 'Pipeline' }
            Get-TimeoutSeconds -Command Sync-Widget | Should -Be 900
        }

        It 'lets a commands entry in timeouts.yml override the decoration' {
            Mock Get-Config -ModuleName Catzc.Base.Timeouts -ParameterFilter { $Config -eq 'timeouts' } {
                [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ commands = @{ 'Sync-Widget' = 45 } })
            }
            Get-TimeoutSeconds -Command Sync-Widget | Should -Be 45
        }

        It "falls back to the environment's pwsh limit for an undecorated function" {
            Get-TimeoutSeconds -Command Sync-Gadget | Should -Be 8
        }

        It "raises the limit to the exemption ceiling while the decoration's budget is exempt, never lowering it" {
            Mock Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts { @{ reason = 'tuning' } }
            Mock Get-Config -ModuleName Catzc.Base.Timeouts -ParameterFilter { $Config -eq 'timeout-exemptions' } {
                [Catzc.Base.Timeouts.TimeoutExemptionsConfig]::new([ordered]@{ ceiling = @{ devbox = @{ pwsh = 300; bash = 50 } } })
            }
            Get-TimeoutSeconds -Command Sync-Gizmo | Should -Be 300
            Should -Invoke Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { "$Budget" -eq $script:gizmoBudget }
        }

        It 'does not ask about an exemption for a function without a budget' {
            Get-TimeoutSeconds -Command Sync-Widget | Out-Null
            Should -Invoke Get-TimeoutExemption -ModuleName Catzc.Base.Timeouts -Times 0
        }

        It 'throws for a function that is not loaded' {
            { Get-TimeoutSeconds -Command Sync-Nothing } | Should -Throw "*no loaded function named 'Sync-Nothing'*"
        }
    }
}
