<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
    kind: test
---
#>

# Logic tests for Get-BicepParameterViolations (with its per-entry and Key Vault reference checks): each violation kind
# against a fixture main.json (tests/assets/parameter-model/main.json, widget/gadget parameters —
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) and a rendered parameters file each
# test writes, plus a clean case. No az: main.json is written as a current build, so the model is read without
# building. Discovery binds to the fixture templates ('sample', configs alpha/beta) and the output to this file's
# $TestDrive through the seams ([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)).
Describe 'Get-BicepParameterViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        # A current build never calls Build-Bicep; this mock makes any call fail loudly instead of reaching az.
        Mock Build-Bicep { throw 'Build-Bicep must not run: the fixture main.json is a current build' } -ModuleName Catzc.Azure.Templates

        $script:outputFolder = (Get-BicepTemplate sample).output_folder
        [System.IO.Directory]::CreateDirectory($script:outputFolder) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:outputFolder 'main.json'), [System.IO.File]::ReadAllText(
                (Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/parameter-model/main.json')))

        # The subscription id is built at runtime: a literal empty guid is denied in tracked text (Test-ManagedGuids).
        $script:vaultId = "/subscriptions/$([guid]::Empty)/resourceGroups/widget-rg/providers/Microsoft.KeyVault/vaults/widget-kv"

        # A parameters file that satisfies the fixture model: every required parameter, a Key Vault reference for the
        # secure one. Each test starts from it and changes one thing.
        function New-ConformingParameterSet {
            [ordered]@{
                widgetName   = @{ value = 'widget-one' }
                gadgetCount  = @{ value = 3 }
                widgetSecret = @{ reference = [ordered]@{ keyVault = @{ id = $script:vaultId }; secretName = 'widget-secret' } }
            }
        }

        function Write-ParameterFile {
            param([System.Collections.IDictionary] $Parameters, [string] $Name = 'parameters.alpha.json')
            [System.IO.File]::WriteAllText((Join-Path $script:outputFolder $Name), ([ordered]@{ parameters = $Parameters } | ConvertTo-Json -Depth 10))
        }

        function Get-Violation {
            @(InModuleScope Catzc.Azure.Templates { Get-BicepParameterViolations sample })
        }
    }

    BeforeEach {
        foreach ($stale in @([System.IO.Directory]::EnumerateFiles($script:outputFolder, 'parameters.*.json'))) {
            [System.IO.File]::Delete($stale)
        }
    }

    It 'reports nothing for a conforming parameters file' {
        $parameters = New-ConformingParameterSet
        $parameters['widgetSku'] = @{ value = 'standard' }
        $parameters['widgetZones'] = @{ value = @('1', '3') }
        $parameters['widgetLabel'] = @{ value = $null }
        $parameters['gadgetEnabled'] = @{ value = $false }
        $parameters['gadgetTags'] = @{ value = @{ owner = 'gadget' } }
        Write-ParameterFile $parameters
        Get-Violation | Should -BeNullOrEmpty
    }

    It 'checks every rendered parameters file and names it in each message' {
        Write-ParameterFile (New-ConformingParameterSet)
        $parameters = New-ConformingParameterSet
        $parameters.Remove('gadgetCount')
        Write-ParameterFile $parameters -Name 'parameters.beta.json'
        Get-Violation | Should -Be @("sample/parameters.beta.json: parameter 'gadgetCount' is required (main.json gives it no default) but is not supplied")
    }

    It 'reports a parameter main.json does not declare' {
        $parameters = New-ConformingParameterSet
        $parameters['gizmoName'] = @{ value = 'gizmo' }
        Write-ParameterFile $parameters
        Get-Violation | Should -Be @("sample/parameters.alpha.json: parameter 'gizmoName' is not declared by the template's main.json")
    }

    It 'reports a value whose type does not match the declared type' {
        $parameters = New-ConformingParameterSet
        $parameters['gadgetCount'] = @{ value = '3' }
        $parameters['gadgetEnabled'] = @{ value = 'true' }
        $parameters['widgetName'] = @{ value = 42 }
        $parameters['gadgetTags'] = @{ value = 1.5 }
        Write-ParameterFile $parameters
        $violations = Get-Violation
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'gadgetCount' is a JSON string, but main.json declares it int"
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'gadgetEnabled' is a JSON string, but main.json declares it bool"
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'widgetName' is an integer, but main.json declares it string"
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'gadgetTags' is a non-integer number, but main.json declares it object"
        $violations.Count | Should -Be 4
    }

    It 'reports null for a parameter that is not nullable' {
        $parameters = New-ConformingParameterSet
        $parameters['widgetName'] = @{ value = $null }
        Write-ParameterFile $parameters
        Get-Violation | Should -Be @("sample/parameters.alpha.json: parameter 'widgetName' is null, but main.json declares it string and not nullable")
    }

    It 'reports a value outside @allowed, and each array element outside it' {
        $parameters = New-ConformingParameterSet
        $parameters['widgetSku'] = @{ value = 'Premium' }
        $parameters['widgetZones'] = @{ value = @('1', '4') }
        Write-ParameterFile $parameters
        $violations = Get-Violation
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'widgetSku' is `"Premium`", which is not one of the @allowed values (Basic, Standard)"
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'widgetZones' contains `"4`", which is not one of the @allowed values (1, 2, 3)"
        $violations.Count | Should -Be 2
    }

    It 'reports an int outside @minValue and @maxValue' {
        $parameters = New-ConformingParameterSet
        $parameters['gadgetCount'] = @{ value = 0 }
        Write-ParameterFile $parameters
        Get-Violation | Should -Be @("sample/parameters.alpha.json: parameter 'gadgetCount' is 0, below @minValue 1")

        $parameters['gadgetCount'] = @{ value = 6 }
        Write-ParameterFile $parameters
        Get-Violation | Should -Be @("sample/parameters.alpha.json: parameter 'gadgetCount' is 6, above @maxValue 5")
    }

    It 'reports a string or array length outside @minLength and @maxLength' {
        $parameters = New-ConformingParameterSet
        $parameters['widgetName'] = @{ value = 'wi' }
        $parameters['widgetLabel'] = @{ value = 'widget-label' }
        $parameters['widgetZones'] = @{ value = @('1', '2', '3') }
        Write-ParameterFile $parameters
        $violations = Get-Violation
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'widgetName' has length 2, below @minLength 3"
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'widgetLabel' has length 12, above @maxLength 8"
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'widgetZones' has length 3, above @maxLength 2"
        $violations.Count | Should -Be 3
    }

    It 'reports every required parameter the file does not supply' {
        Write-ParameterFile ([ordered]@{ widgetName = @{ value = 'widget-one' } })
        Get-Violation | Should -Be @(
            "sample/parameters.alpha.json: parameter 'gadgetCount' is required (main.json gives it no default) but is not supplied"
            "sample/parameters.alpha.json: parameter 'widgetSecret' is required (main.json gives it no default) but is not supplied"
        )
    }

    It 'reports a literal value for a secure parameter without printing the value' {
        $parameters = New-ConformingParameterSet
        $parameters['widgetSecret'] = @{ value = 'gadget-literal-secret' }
        $parameters['gadgetSettings'] = @{ value = @{ token = 'gadget-literal-token' } }
        Write-ParameterFile $parameters
        $violations = Get-Violation
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'widgetSecret' is a secureString parameter set to a literal value — it takes only a Key Vault reference"
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'gadgetSettings' is a secureObject parameter set to a literal value — it takes only a Key Vault reference"
        $violations.Count | Should -Be 2
        ($violations -join "`n") | Should -Not -Match 'gadget-literal'
    }

    It 'reports a Key Vault reference that is not well-formed' {
        $parameters = New-ConformingParameterSet
        $parameters['widgetSecret'] = @{ reference = @{ keyVault = @{ id = 'widget-kv' } } }
        Write-ParameterFile $parameters
        Get-Violation | Should -Be @(
            "sample/parameters.alpha.json: parameter 'widgetSecret' has a Key Vault reference whose keyVault.id is not a vault resource id (/subscriptions/…/providers/Microsoft.KeyVault/vaults/<name>)"
            "sample/parameters.alpha.json: parameter 'widgetSecret' has a Key Vault reference without a secretName"
        )
    }

    It 'reports an entry with both a value and a reference, or neither' {
        $parameters = New-ConformingParameterSet
        $parameters['widgetName'] = @{ value = 'widget-one'; reference = @{ secretName = 'widget' } }
        $parameters['gadgetCount'] = @{ count = 3 }
        Write-ParameterFile $parameters
        $violations = Get-Violation
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'widgetName' sets both a 'value' and a 'reference'"
        $violations | Should -Contain "sample/parameters.alpha.json: parameter 'gadgetCount' sets neither a 'value' nor a 'reference'"
        $violations.Count | Should -Be 2
    }

    It 'reports a parameters file that is not valid JSON or has no parameters object' {
        [System.IO.File]::WriteAllText((Join-Path $script:outputFolder 'parameters.alpha.json'), '{ not json')
        [System.IO.File]::WriteAllText((Join-Path $script:outputFolder 'parameters.beta.json'), '{ "widgetName": { "value": "widget-one" } }')
        $violations = Get-Violation
        $violations[0] | Should -BeLike 'sample/parameters.alpha.json: is not valid JSON (*'
        $violations[1] | Should -Be "sample/parameters.beta.json: has no 'parameters' object"
        $violations.Count | Should -Be 2
    }
}
