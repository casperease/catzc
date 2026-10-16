<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1
    folder: tests
    name: invoke-config-validator-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.ConfigExtensions
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-configextensions/tests/Invoke-ConfigValidator.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Invoke-ConfigValidator' -Tag 'L0', 'logic' {
    BeforeAll {
        New-Module -Name TstWidget -ScriptBlock {
            function Assert-WidgetPartsConfig {
                param($Config)
                if (-not $Config.Contains('size')) {
                    throw 'widget-parts.yml: size is required'
                }
                'validator output is discarded'
            }
            function Assert-GadgetRules {
                param($Config)
                if ($Config['mode'] -ne 'on') {
                    throw 'gadget.yml: mode must be on'
                }
            }
            Export-ModuleMember
        } | Import-Module
    }

    AfterAll {
        Remove-Module TstWidget -ErrorAction Ignore
    }

    It 'runs the conventional validator privately in the owner scope and returns its name' {
        Invoke-ConfigValidator -Config ([ordered]@{ size = 3 }) -Name widget-parts -Module TstWidget |
            Should -Be 'Assert-WidgetPartsConfig'
    }

    It 'propagates the validator throw' {
        { Invoke-ConfigValidator -Config ([ordered]@{}) -Name widget-parts -Module TstWidget } |
            Should -Throw '*size is required*'
    }

    It 'runs a validator named with -Validator instead of the conventional one' {
        Invoke-ConfigValidator -Config ([ordered]@{ mode = 'on' }) -Name gadget -Module TstWidget -Validator Assert-GadgetRules |
            Should -Be 'Assert-GadgetRules'
        { Invoke-ConfigValidator -Config ([ordered]@{ mode = 'off' }) -Name gadget -Module TstWidget -Validator Assert-GadgetRules } |
            Should -Throw '*mode must be on*'
    }

    It 'returns nothing when no conventional validator exists' {
        Invoke-ConfigValidator -Config ([ordered]@{}) -Name sprocket -Module TstWidget | Should -BeNullOrEmpty
    }

    It 'throws when a named validator does not exist' {
        { Invoke-ConfigValidator -Config ([ordered]@{}) -Name gadget -Module TstWidget -Validator Assert-Missing } |
            Should -Throw "*validator 'Assert-Missing' is not defined in module 'TstWidget'*"
    }

    It 'throws when the owning module is not loaded' {
        { Invoke-ConfigValidator -Config ([ordered]@{}) -Name gadget -Module TstNotLoaded } |
            Should -Throw "*owning module 'TstNotLoaded' is not loaded*"
    }
}
