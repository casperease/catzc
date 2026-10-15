<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-DSGN-RUNMODE#3
---
#>

# Scope isolation: two catzc modules that hold a $script: variable of the same name never see each other's value — in...
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md#comment1)
Describe 'Module script scopes are never shared' -Tag 'ADR-DSGN-RUNMODE#3' {
    BeforeAll {
        $script:probeName = 'catzcScopeIsolationProbe'

        # Sets the probe in each module's script scope (widget, gadget, …), reads every module's variable and the...
        # [comment:2](/docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md#comment2)
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

    # In-process, in whichever mode this session runs: the source run proves the source mode, the build run (where...
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md#comment3)
    Context 'in the loaded session' -Tag 'L1', 'logic' {
        It 'gives each module its own value for the same variable name, invisible to the session' {
            $result = & $script:probeBlock $script:probeName

            $result.Observed | Should -HaveCount 2
            $result.Observed[0].Value | Should -Be 'widget'
            $result.Observed[1].Value | Should -Be 'gadget'
            $result.Global | Should -BeNullOrEmpty
        }
    }

    # A fresh build entered in a child pwsh.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md#comment4)
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
