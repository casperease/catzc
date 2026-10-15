<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
    kind: test
---
#>

# Scope isolation ([ADR-DSGN-RUNMODE#3](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode3)): two catzc modules that
# hold a $script: variable of the same name never see
# each other's value — in either run mode. The probe variable name is the test's own and is removed afterwards; no
# module code reads it. The modules are chosen generically (the first two loaded catzc modules by name), never by
# a production identity.
Describe 'Module script scopes are never shared' -Tag 'ADR-DSGN-RUNMODE#3' {
    BeforeAll {
        $script:probeName = 'catzcScopeIsolationProbe'

        # Sets the probe in each module's script scope (widget, gadget, …), reads every module's variable and the
        # global one back, then removes the probes. Self-contained so it also runs in a child pwsh.
        $script:probeBlock = {
            param([string] $ProbeName)
            $modules = @(Get-Module 'Catzc.*' | Where-Object { $_.Name -notlike 'Catzc.Internal.*' -and $_.Name -ne 'Catzc' } |
                    Sort-Object Name | Select-Object -First 2)
            $values = @('widget', 'gadget')
            for ($index = 0; $index -lt $modules.Count; $index++) {
                & $modules[$index] { param($Name, $Value) Set-Variable -Scope Script -Name $Name -Value $Value } $ProbeName $values[$index]
            }
            $observed = foreach ($module in $modules) {
                [pscustomobject]@{
                    Module     = $module.Name
                    ModuleBase = $module.ModuleBase
                    Value      = & $module { param($Name) Get-Variable -Scope Script -Name $Name -ValueOnly -ErrorAction Ignore } $ProbeName
                }
            }
            foreach ($module in $modules) {
                & $module { param($Name) Remove-Variable -Scope Script -Name $Name -ErrorAction Ignore } $ProbeName
            }
            [pscustomobject]@{
                RunMode  = Get-CatzcRunMode
                Observed = @($observed)
                Global   = Get-Variable -Scope Global -Name $ProbeName -ValueOnly -ErrorAction Ignore
            }
        }
    }

    # In-process, in whichever mode this session runs: the source run proves the source mode, the build run (where
    # this file runs against the built modules) proves build mode.
    Context 'in the loaded session' -Tag 'L1', 'logic' {
        It 'gives each module its own value for the same variable name, invisible to the session' {
            $result = & $script:probeBlock $script:probeName

            $result.Observed | Should -HaveCount 2
            $result.Observed[0].Value | Should -Be 'widget'
            $result.Observed[1].Value | Should -Be 'gadget'
            $result.Global | Should -BeNullOrEmpty
        }
    }

    # A fresh build entered in a child pwsh. source-only: it builds from the source tree itself (Build-Modules needs
    # the per-function files) and isolates the build in its own process, so the answer does not depend on the mode
    # of the session running it. greedy: one build plus one importer-loading child pwsh.
    Context 'in a fresh build' -Tag 'L2', 'logic', 'greedy', 'source-only' {
        BeforeAll {
            $script:buildAvailable = [bool](Get-Command Build-Modules -ErrorAction Ignore)
            if ($script:buildAvailable) {
                Import-InternalModule TestKit
                # The harness's own module and its dependency closure — more than two modules, built quickly.
                $script:handle = New-BuiltCatzcRoot -Module (Get-Command Test-CatzcBuild).Module.Name
                $script:built = Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock $script:probeBlock -ArgumentList $script:probeName
            }
        }
        AfterAll {
            if ($script:buildAvailable -and $script:handle) {
                Remove-BuiltCatzcRoot $script:handle
            }
        }

        It 'loads the built modules in build mode, from the build root' {
            if (-not $script:buildAvailable) {
                Set-ItResult -Skipped -Because 'tool_build_modules_missing'
                return
            }
            $script:built.RunMode | Should -Be 'build'
            $buildRoot = [System.IO.Path]::GetFullPath($script:handle.BuildRoot)
            foreach ($observed in $script:built.Observed) {
                [System.IO.Path]::GetFullPath($observed.ModuleBase) | Should -BeLike "$buildRoot*"
            }
        }

        It 'gives each built module its own value for the same variable name, invisible to the session' {
            if (-not $script:buildAvailable) {
                Set-ItResult -Skipped -Because 'tool_build_modules_missing'
                return
            }
            $script:built.Observed | Should -HaveCount 2
            $script:built.Observed[0].Value | Should -Be 'widget'
            $script:built.Observed[1].Value | Should -Be 'gadget'
            $script:built.Global | Should -BeNullOrEmpty
        }
    }
}
