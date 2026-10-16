<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
    folder: tests
    name: get-bicep-parameter-model-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#2
---
#>

Describe 'Get-BicepParameterModel' -Tag 'L0', 'logic' {
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

        $script:fixtureJson = [System.IO.File]::ReadAllText(
            (Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/parameter-model/main.json'))
        $script:outputFolder = (Get-BicepTemplate sample).output_folder
        $script:mainJson = Join-Path $script:outputFolder 'main.json'

        function Write-FixtureBuild {
            [System.IO.Directory]::CreateDirectory($script:outputFolder) | Out-Null
            [System.IO.File]::WriteAllText($script:mainJson, $script:fixtureJson)
        }

        Mock Build-Bicep { Write-FixtureBuild } -ModuleName Catzc.Azure.Templates
    }

    Context 'the parsed model' {
        BeforeAll {
            Write-FixtureBuild
            $script:model = Get-BicepParameterModel sample
        }

        It 'names the template and declares every parameter of main.json' {
            $script:model | Should -BeOfType ([Catzc.Azure.Templates.BicepParameterModel])
            $script:model.Template | Should -Be 'sample'
            @($script:model.Parameters.Keys | Sort-Object) | Should -Be @(
                'gadgetCount', 'gadgetEnabled', 'gadgetSettings', 'gadgetTags', 'location',
                'widgetLabel', 'widgetName', 'widgetSecret', 'widgetSku', 'widgetZones'
            )
        }

        It 'keys the parameters case-insensitively, as ARM matches names' {
            $script:model.Parameters.ContainsKey('WidgetName') | Should -BeTrue
        }

        It 'canonicalizes the ARM type spelling' {
            $script:model.Parameters['widgetSecret'].Type | Should -Be 'secureString'
            $script:model.Parameters['widgetSecret'].IsSecure | Should -BeTrue
            $script:model.Parameters['gadgetSettings'].Type | Should -Be 'secureObject'
            $script:model.Parameters['gadgetCount'].Type | Should -Be 'int'
            $script:model.Parameters['gadgetEnabled'].Type | Should -Be 'bool'
            $script:model.Parameters['gadgetTags'].Type | Should -Be 'object'
            $script:model.Parameters['widgetZones'].Type | Should -Be 'array'
        }

        It 'reads a defaultValue as HasDefault, and a parameter without one as required' {
            $script:model.Parameters['location'].HasDefault | Should -BeTrue
            $script:model.Parameters['location'].IsRequired | Should -BeFalse
            $script:model.Parameters['widgetName'].HasDefault | Should -BeFalse
            $script:model.Parameters['widgetName'].IsRequired | Should -BeTrue
        }

        It 'reads @allowed values and the value and length bounds' {
            @($script:model.Parameters['widgetSku'].AllowedValues) | Should -Be @('Basic', 'Standard')
            $script:model.Parameters['gadgetCount'].MinValue | Should -Be 1
            $script:model.Parameters['gadgetCount'].MaxValue | Should -Be 5
            $script:model.Parameters['widgetName'].MinLength | Should -Be 3
            $script:model.Parameters['widgetName'].MaxLength | Should -Be 12
            $script:model.Parameters['widgetName'].AllowedValues.Count | Should -Be 0
        }

        It 'resolves a user-defined type through its definition and reads nullable as not required' {
            $label = $script:model.Parameters['widgetLabel']
            $label.Type | Should -Be 'string'
            $label.MaxLength | Should -Be 8
            $label.Nullable | Should -BeTrue
            $label.IsRequired | Should -BeFalse
        }
    }

    Context 'a malformed main.json' {
        It 'throws naming the template and the parameter for an unknown type' {
            { [Catzc.Azure.Templates.BicepParameterModel]::Parse('widget', '{"parameters":{"gadgetName":{"type":"gizmo"}}}') } |
                Should -Throw '*widget*gadgetName*gizmo*'
        }

        It 'throws for a $ref to a definition main.json does not declare' {
            { [Catzc.Azure.Templates.BicepParameterModel]::Parse('widget', '{"parameters":{"gadgetName":{"$ref":"#/definitions/missing"}}}') } |
                Should -Throw '*gadgetName*missing*'
        }

        It 'returns an empty model for a template without parameters' {
            [Catzc.Azure.Templates.BicepParameterModel]::Parse('widget', '{"resources":{}}').Parameters.Count | Should -Be 0
        }
    }

    Context 'building when no current build exists' {
        BeforeEach {
            if ([System.IO.Directory]::Exists($script:outputFolder)) {
                [System.IO.Directory]::Delete($script:outputFolder, $true)
            }
        }

        It 'builds the template when its output folder holds no main.json' {
            Get-BicepParameterModel sample | Out-Null
            Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 1 -Exactly
        }

        It 'builds the template when main.json is older than one of its inputs' {
            Write-FixtureBuild
            [System.IO.File]::SetLastWriteTimeUtc($script:mainJson, [datetime]::new(2000, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc))
            Get-BicepParameterModel sample | Out-Null
            Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 1 -Exactly
        }

        It 'reads a current build without building' {
            Write-FixtureBuild
            Get-BicepParameterModel sample | Out-Null
            Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 0 -Exactly
        }
    }
}
