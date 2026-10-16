<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.Templates
    relatives:
      page: docs/references/automation/catzc-azure-templates/tests/Assert-BicepTemplate.Tests.ps1.md
      source: automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-REPO-OUTDIR#3
---
#>

# cspell:ignore brkn
Describe 'Assert-BicepTemplate' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixtureTemplates = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'

        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }

        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
    }

    Context 'valid templates (read-only)' {
        BeforeAll {
            Mock Get-BicepTemplatesRoot { $script:fixtureTemplates } -ModuleName Catzc.Azure.Templates
        }

        It 'passes for a valid non-slotted template' {
            { Assert-BicepTemplate sample } | Should -Not -Throw
        }

        It 'passes for a template whose configs all carry slots' {
            { Assert-BicepTemplate sample-indexed } | Should -Not -Throw
        }

        It 'passes for a valid subscription-kind template' {
            { Assert-BicepTemplate sample-subenv } | Should -Not -Throw
        }

        It 'throws for an unknown template' {
            { Assert-BicepTemplate does-not-exist } | Should -Throw '*not found*'
        }
    }

    Context 'violations (each corrupts the tree)' {
        BeforeEach {
            $script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())
            Copy-Directory $script:fixtureTemplates $script:templatesRoot

            Mock Get-BicepTemplatesRoot { $script:templatesRoot } -ModuleName Catzc.Azure.Templates
        }

        It 'accepts a template that MIXES slotted and non-slotted configs (slot is per-config)' {
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/beta-001.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate sample } | Should -Not -Throw
        }

        It 'reports an env-class violation (per-subscription env on a standard template)' {
            # nsub is a per-subscription env; placing it on a standard template trips the env-class rule.
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/nsub.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate sample } | Should -Throw '*environment_kind*'
        }

        It 'reports a config whose coordinate resolves to no subscription' {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:templatesRoot 'sample/configuration/globex')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/globex/alpha.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate sample } | Should -Throw '*cannot be resolved*'
        }

        It 'reports a parameter the template does not declare' {
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/beta-001.yml'), "ParametersFile:`n  parameters:`n    bogusParam:`n      value: 1")
            { Assert-BicepTemplate sample } | Should -Throw '*bogusParam*'
        }

        It 'reports a subfolder that is not a customer key' {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:templatesRoot 'sample/configuration/zzz')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/zzz/alpha.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate sample } | Should -Throw '*not a customer key*'
        }

        It 'reports a missing main.bicep' {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:templatesRoot 'broken/configuration')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'broken/options.yml'), 'short_name: brkn')
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'broken/configuration/alpha.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate broken } | Should -Throw '*main.bicep*'
        }

        It 'collects multiple violations into one consolidated error' {
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/nsub.yml'), "ParametersFile:`n  parameters:`n    bogusParam:`n      value: 1")
            $err = $null
            try {
                Assert-BicepTemplate sample
            }
            catch {
                $err = $_.Exception.Message
            }
            $err | Should -Match 'environment_kind'
            $err | Should -Match 'bogusParam'
        }
    }

    Context '-Build (the parameter model check)' {
        BeforeAll {
            Mock Get-BicepTemplatesRoot { $script:fixtureTemplates } -ModuleName Catzc.Azure.Templates
            Mock Get-Command { [pscustomobject]@{ Name = 'az' } } -ModuleName Catzc.Azure.Templates -ParameterFilter { $Name -eq 'az' }
            Mock Build-Bicep { } -ModuleName Catzc.Azure.Templates
            Mock Get-BicepParameterViolations {
                "sample/parameters.alpha.json: parameter 'widgetName' has length 2, below @minLength 3"
            } -ModuleName Catzc.Azure.Templates
        }

        It 'builds the template and reports each parameter violation' {
            { Assert-BicepTemplate sample -Build } |
                Should -Throw "*[[]sample[]] sample/parameters.alpha.json: parameter 'widgetName' has length 2, below @minLength 3*"
            Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter { $Template -eq 'sample' }
        }

        It 'reports a failed build and skips the parameter check' {
            Mock Build-Bicep { throw 'widget compile error' } -ModuleName Catzc.Azure.Templates
            { Assert-BicepTemplate sample -Build } | Should -Throw '*Build-Bicep failed: widget compile error*'
            Should -Invoke Get-BicepParameterViolations -ModuleName Catzc.Azure.Templates -Times 0 -Exactly
        }

        It 'neither builds nor checks parameters without -Build' {
            { Assert-BicepTemplate sample } | Should -Not -Throw
            Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 0 -Exactly
            Should -Invoke Get-BicepParameterViolations -ModuleName Catzc.Azure.Templates -Times 0 -Exactly
        }
    }
}
