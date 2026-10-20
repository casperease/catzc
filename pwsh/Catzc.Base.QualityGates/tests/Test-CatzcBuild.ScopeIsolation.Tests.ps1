<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
    folder: tests
    name: test-catzc-build-scope-isolation-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Test-CatzcBuild.ScopeIsolation.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md)"
    cites:
      - ADR-DSGN-RUNMODE-OWNSCRIPTSCOPE
---
#>

Describe 'Module script scopes are never shared' -Tag 'ADR-DSGN-RUNMODE-OWNSCRIPTSCOPE' {
    BeforeAll {
        $script:probeName = 'catzcScopeIsolationProbe'

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

    Context 'in the loaded session' -Tag 'L1', 'logic' {
        It 'gives each module its own value for the same variable name, invisible to the session' {
            $result = & $script:probeBlock $script:probeName

            $result.Observed | Should -HaveCount 2
            $result.Observed[0].Value | Should -Be 'widget'
            $result.Observed[1].Value | Should -Be 'gadget'
            $result.Global | Should -BeNullOrEmpty
        }
    }

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
